import os
import json

# Đọc dữ liệu từ file JSON
with open(r"E:\Lab\Tracking\AIC22\test_tracks.json", "r") as f:
    data = json.load(f)

# Output folder lưu nhãn kiểu YOLO
output_dir = r"E:\Lab\Tracking\AIC22\Yolo_label"
os.makedirs(output_dir, exist_ok=True)

# Kích thước ảnh - điều chỉnh nếu khác
image_width = 1920
image_height = 1080

def convert_to_yolo_format(box, img_w, img_h):
    """Chuyển đổi bounding box về định dạng YOLO"""
    x, y, w, h = box
    x_center = (x + w / 2) / img_w
    y_center = (y + h / 2) / img_h
    w_norm = w / img_w
    h_norm = h / img_h
    return [1, x_center, y_center, w_norm, h_norm]  # class_id = 1 (car)

for obj_id, obj_data in data.items():
    frames = obj_data["frames"]
    boxes = obj_data["boxes"]
    
    for frame_path, box in zip(frames, boxes):
        if box:  # Kiểm tra xem có bbox hay không
            yolo_box = convert_to_yolo_format(box, image_width, image_height)
            
            # Lấy tên ảnh từ đường dẫn đầy đủ (ví dụ: "./train/S01/c001/img1/000447.jpg")
            img_filename = os.path.basename(frame_path)  # 000447.jpg
            txt_filename = img_filename.replace(".jpg", ".txt")  # 000447.txt
            
            # Lấy toàn bộ đường dẫn từ thư mục gốc (bao gồm train/S01/c001/img1/000447.jpg)
            relative_dir = os.path.dirname(frame_path)  # train/S01/c001/img1
            
            # Tạo đường dẫn thư mục lưu nhãn
            label_dir = os.path.join(output_dir, relative_dir)
            os.makedirs(label_dir, exist_ok=True)
            
            # Lưu tệp nhãn
            txt_path = os.path.join(label_dir, txt_filename)
            with open(txt_path, "a") as f:
                # Đảm bảo class là số nguyên
                f.write(f"{int(yolo_box[0])} " + " ".join(f"{v:.6f}" for v in yolo_box[1:]) + "\n")

print("✅ Đã tạo các tệp nhãn với class = 1 (car 1 class = 1 (car) và đúng đường dẫn.")