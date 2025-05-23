import json
import os

# Đường dẫn file gốc và file mới
input_json_path = r"E:\Lab\Tracking\AIC22\train_tracks.json"
output_json_path = r"E:\Lab\Tracking\AIC22\ttrain_tracks_1280x720.json"

# Hệ số scale
scale_x = 1280 / 1920
scale_y = 720 / 1080

# Đọc dữ liệu gốc
with open(input_json_path, "r") as f:
    tracks = json.load(f)

# Cập nhật bbox đã scale
for track_id, track_data in tracks.items():
    scaled_boxes = []
    for box in track_data["boxes"]:
        x, y, w, h = box
        x = int(x * scale_x)
        y = int(y * scale_y)
        w = int(w * scale_x)
        h = int(h * scale_y)
        scaled_boxes.append([x, y, w, h])
    track_data["boxes"] = scaled_boxes  # cập nhật lại box đã scale

# Ghi lại ra file mới
with open(output_json_path, "w") as f:
    json.dump(tracks, f)

print(f"✅ Đã lưu file mới với bbox scaled tại: {output_json_path}")
