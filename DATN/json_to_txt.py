import json
import os
import pandas as pd
import numpy as np
from itertools import product
from collections import defaultdict
from PIL import Image
import cv2

def resize_roi_image(input_path, output_path, new_size=(1280, 720)):
    """Resize ROI image to specified size."""
    try:
        img = Image.open(input_path)
        img_resized = img.resize(new_size, Image.Resampling.LANCZOS)
        img_resized.save(output_path)
        print(f"✅ Resized ROI image saved to: {output_path}")
    except Exception as e:
        print(f"❌ Error resizing ROI image: {e}")

def is_box_in_roi(box, roi_mask, threshold=0.8):
    """Check if at least 80% of the bounding box area lies within the white region of ROI mask."""
    x, y, w, h = box
    x, y, w, h = int(x), int(y), int(w), int(h)
    
    box_mask = np.zeros_like(roi_mask)
    box_mask[y:y+h, x:x+w] = 255
    
    intersection = cv2.bitwise_and(box_mask, roi_mask)
    intersection_area = np.sum(intersection) / 255.0
    box_area = w * h
    
    return intersection_area / box_area >= threshold if box_area > 0 else False

def calculate_iou(box1, box2):
    x1, y1, w1, h1 = box1
    x2, y2, w2, h2 = box2
    
    xi1 = max(x1, x2)
    yi1 = max(y1, y2)
    xi2 = min(x1 + w1, x2 + w2)
    yi2 = min(y1 + h1, y2 + h2)
    
    inter_area = max(0, xi2 - xi1) * max(0, yi2 - yi1)
    box1_area = w1 * h1
    box2_area = w2 * h2
    union_area = box1_area + box2_area - inter_area
    
    return inter_area / union_area if union_area > 0 else 0

def json_to_mot_txt(json_data, output_dir, is_gt=True, roi_mask_path=None):
    os.makedirs(output_dir, exist_ok=True)
    sequence_data = defaultdict(list)
    gt_id_map = {}
    new_id = 1

    roi_mask = None
    if roi_mask_path and os.path.exists(roi_mask_path):
        roi_mask = cv2.imread(roi_mask_path, cv2.IMREAD_GRAYSCALE)
        if roi_mask is None:
            print(f"❌ Error loading ROI mask: {roi_mask_path}")
            roi_mask = None

    for track_id, track_data in json_data.items():
        frames = track_data.get("frames", [])
        boxes = track_data.get("boxes", [])
        ids = track_data.get("ids", [track_id] * len(boxes))
        confs = track_data.get("conf", [1.0] * len(boxes))

        if len(frames) == 0 or len(boxes) == 0:
            continue

        min_len = min(len(frames), len(boxes), len(ids), len(confs))
        if min_len == 0:
            continue
        frames = frames[:min_len]
        boxes = boxes[:min_len]
        ids = ids[:min_len]
        confs = confs[:min_len]

        try:
            example_path = frames[0]
            seq_parts = example_path.replace("\\", "/").split("/")
            if len(seq_parts) >= 3:
                seq_name = f"{seq_parts[-3]}_{seq_parts[-2]}"
            else:
                seq_name = track_id
        except:
            continue

        for i, (frame_path, box, obj_id, conf) in enumerate(zip(frames, boxes, ids, confs)):
            try:
                frame_id = int(os.path.splitext(os.path.basename(frame_path))[0])
                if not isinstance(box, (list, tuple)) or len(box) != 4:
                    raise ValueError(f"Invalid bounding box: {box}")
                x, y, w, h = box
                conf_value = 1.0 if is_gt else float(conf)
                
                if roi_mask is not None:
                    if not is_box_in_roi(box, roi_mask, threshold=0.8):
                        continue
                
                if is_gt:
                    if obj_id not in gt_id_map:
                        gt_id_map[obj_id] = new_id
                        new_id += 1
                    obj_id = gt_id_map[obj_id]

                sequence_data[seq_name].append([frame_id, obj_id, x, y, w, h, conf_value, -1, -1, -1])
            except:
                continue

    for seq_name, mot_data in sequence_data.items():
        txt_path = os.path.join(output_dir, f"{seq_name}.txt")
        mot_data = sorted(mot_data, key=lambda x: x[0])
        with open(txt_path, "w") as f_out:
            for row in mot_data:
                f_out.write(",".join(map(str, row)) + "\n")

def match_ids(gt_file, pred_file, output_file, iou_threshold=0.75):
    try:
        gt_data = pd.read_csv(gt_file, header=None, names=['frame_id', 'object_id', 'x', 'y', 'w', 'h', 'conf', 'class_id', 'vis', 'unused'])
        pred_data = pd.read_csv(pred_file, header=None, names=['frame_id', 'object_id', 'x', 'y', 'w', 'h', 'conf', 'class_id', 'vis', 'unused'])
    except Exception as e:
        print(f"❌ Error reading GT or Pred file: {e}")
        return

    pred_data = pred_data.copy()
    id_mapping = {}

    for frame_id in gt_data['frame_id'].unique():
        gt_frame = gt_data[gt_data['frame_id'] == frame_id]
        pred_frame = pred_data[pred_data['frame_id'] == frame_id]
        
        if gt_frame.empty or pred_frame.empty:
            continue

        iou_matrix = np.zeros((len(gt_frame), len(pred_frame)))
        for i, (_, gt_row) in enumerate(gt_frame.iterrows()):
            gt_box = [gt_row['x'], gt_row['y'], gt_row['w'], gt_row['h']]
            for j, (_, pred_row) in enumerate(pred_frame.iterrows()):
                pred_box = [pred_row['x'], pred_row['y'], pred_row['w'], pred_row['h']]
                iou_matrix[i, j] = calculate_iou(gt_box, pred_box)
        
        gt_indices, pred_indices = list(range(len(gt_frame))), list(range(len(pred_frame)))
        for _ in range(min(len(gt_frame), len(pred_frame))):
            max_iou = 0
            best_gt_idx, best_pred_idx = None, None
            for i, j in product(gt_indices, pred_indices):
                if iou_matrix[i, j] > max_iou and iou_matrix[i, j] > iou_threshold:
                    max_iou = iou_matrix[i, j]
                    best_gt_idx, best_pred_idx = i, j
            if best_gt_idx is not None and best_pred_idx is not None:
                gt_id = gt_frame.iloc[best_gt_idx]['object_id']
                pred_id = pred_frame.iloc[best_pred_idx]['object_id']
                id_mapping[pred_id] = gt_id
                gt_indices.remove(best_gt_idx)
                pred_indices.remove(best_pred_idx)

    pred_data['object_id'] = pred_data['object_id'].map(lambda x: id_mapping.get(x, x))
    
    pred_data.to_csv(output_file, header=False, index=False)
    print(f"✅ ID mapping completed and saved to: {output_file}")

if __name__ == "__main__":
    gt_json = r"E:\Lab\Tracking\AIC22\train\S01\c002\output\ground_truth_200_frames.json"
    pred_json = r"C:\Users\Lenovo\Downloads\tracks_nms_hierarchical.json"
    roi_image = r"E:\Lab\Tracking\AIC22\train\S01\c002\ROI.jpg"
    resized_roi_image = r"E:\Lab\Tracking\AIC22\train\S01\c002\ROI_resized.jpg"

    mot_dir_gt = r"E:\Lab\Tracking\AIC22\mot_files\gt"
    mot_dir_pred = r"E:\Lab\Tracking\AIC22\mot_files\pred"
    mot_dir_matched = r"E:\Lab\Tracking\AIC22\mot_files\matched"

    if os.path.exists(roi_image):
        resize_roi_image(roi_image, resized_roi_image, new_size=(1280, 720))
    else:
        print(f"❌ ROI image not found: {roi_image}")
        resized_roi_image = None

    if not os.path.exists(pred_json):
        print(f"❌ Pred JSON not found: {pred_json}")
        exit(1)
    with open(pred_json, "r") as f:
        pred_data = json.load(f)

    gt_is_txt = gt_json.endswith(".txt")
    if gt_is_txt:
        if not os.path.exists(gt_json):
            print(f"❌ GT TXT not found: {gt_json}")
            exit(1)
        gt_file = gt_json
    else:
        if not os.path.exists(gt_json):
            print(f"❌ GT JSON not found: {gt_json}")
            exit(1)
        with open(gt_json, "r") as f:
            gt_data = json.load(f)
        json_to_mot_txt(gt_data, mot_dir_gt, is_gt=True, roi_mask_path=resized_roi_image)

    json_to_mot_txt(pred_data, mot_dir_pred, is_gt=False, roi_mask_path=resized_roi_image)

    os.makedirs(mot_dir_matched, exist_ok=True)
    for pred_file in os.listdir(mot_dir_pred):
        if pred_file.endswith(".txt"):
            seq_name = os.path.splitext(pred_file)[0]
            gt_file_path = gt_file if gt_is_txt else os.path.join(mot_dir_gt, f"{seq_name}.txt")
            pred_file_path = os.path.join(mot_dir_pred, pred_file)
            matched_file = os.path.join(mot_dir_matched, f"{seq_name}_matched.txt")

            if os.path.exists(gt_file_path):
                print(f"🔄 Mapping IDs for sequence: {seq_name}")
                match_ids(gt_file_path, pred_file_path, matched_file, iou_threshold=0.75)
            else:
                print(f"⚠️ GT file not found for sequence: {seq_name}")

    print("🎯 Conversion and mapping completed!")