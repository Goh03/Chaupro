import motmetrics as mm
import os
import pandas as pd

gt_file = r"E:\Lab\Tracking\AIC22\mot_files\gt\c002_img1.txt"
pred_file = r"E:\Lab\Tracking\AIC22\mot_files\pred\c002_img1.txt"

# Đọc file GT và Pred
gt = pd.read_csv(gt_file, header=None)
pred = pd.read_csv(pred_file, header=None)

gt.columns = ['FrameId', 'Id', 'X', 'Y', 'W', 'H', 'Score', 'Class', 'Visibility', 'Dummy']
pred.columns = ['FrameId', 'Id', 'X', 'Y', 'W', 'H', 'Score', 'Class', 'Visibility', 'Dummy']

# Tạo accumulator
acc = mm.MOTAccumulator(auto_id=True)

# Lặp qua từng frame
for frame_id in sorted(gt['FrameId'].unique()):
    gt_frame = gt[gt['FrameId'] == frame_id]
    pred_frame = pred[pred['FrameId'] == frame_id]

    gt_ids = gt_frame['Id'].tolist()
    gt_boxes = gt_frame[['X', 'Y', 'W', 'H']].values

    pred_ids = pred_frame['Id'].tolist()
    pred_boxes = pred_frame[['X', 'Y', 'W', 'H']].values

    # Tính toán khoảng cách giữa bbox gt và pred
    distances = mm.distances.iou_matrix(gt_boxes, pred_boxes, max_iou=0.5)

    acc.update(gt_ids, pred_ids, distances)

# Tính toán chỉ số
mh = mm.metrics.create()
summary = mh.compute(acc, metrics=mm.metrics.motchallenge_metrics, name='Sequence_1')

# In ra kết quả
print(mm.io.render_summary(summary, formatters=mh.formatters, namemap=mm.io.motchallenge_metric_names))
