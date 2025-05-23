import cv2
import os
import json
import random
from collections import defaultdict

# Đường dẫn đến video gốc
video_path = r"E:\Lab\Tracking\AIC22\train\S01\c002\vdo.mp4"

# Đường dẫn đầu ra cho video visualized
output_video_path = r"E:\Lab\Tracking\AIC22\train\S01\c002\visualized.mp4"

# Đọc dữ liệu từ test_tracks.json
json_path = r"E:\Lab\Tracking\AIC22\train\S01\c002\output\output.json"

# 🔹 Kiểm tra file JSON tồn tại trước khi đọc
if not os.path.exists(json_path):
    print(f"❌ Lỗi: Không tìm thấy file JSON tại {json_path}")
    exit()

with open(json_path, "r") as f:
    try:
        test_tracks = json.load(f)
    except json.JSONDecodeError:
        print("❌ Lỗi: Không thể giải mã JSON.")
        exit()

# Tạo từ điển ánh xạ frame index với danh sách track
frame_to_tracks = defaultdict(list)
track_colors = {}  # Để lưu màu sắc cho mỗi track_id

# Gán màu ngẫu nhiên cho mỗi track_id và ánh xạ frame với bounding box
for track_id, track_data in test_tracks.items():
    frames = track_data["frames"]
    boxes = track_data["boxes"]
    
    # Gán màu ngẫu nhiên cho mỗi track_id
    track_colors[track_id] = (random.randint(0, 255), random.randint(0, 255), random.randint(0, 255))
    
    for frame_path, box in zip(frames, boxes):
        frame_name = os.path.basename(frame_path)  # Ví dụ: 000240.jpg
        frame_idx = int(frame_name.split(".")[0])  # 240
        if "c002" not in frame_path:  # Chỉ xử lý frame từ c001
            continue
        frame_to_tracks[frame_idx].append({
            "track_id": track_id,
            "box": box
        })

# Mở video
if not os.path.exists(video_path):
    print(f"❌ Lỗi: Không tìm thấy video tại {video_path}")
    exit()

cap = cv2.VideoCapture(video_path)
if not cap.isOpened():
    print(f"❌ Không thể mở video: {video_path}")
    exit()

# Lấy thông tin video
fps = cap.get(cv2.CAP_PROP_FPS)
total_frames = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
print(f"🎥 Video FPS: {fps}, Total frames: {total_frames}, Size: {width}x{height}")
delay = int(1000 / fps)

# Thiết lập video đầu ra
fourcc = cv2.VideoWriter_fourcc(*'mp4v')  # Codec MP4
out = cv2.VideoWriter(output_video_path, fourcc, fps, (width, height))
if not out.isOpened():
    print(f"❌ Không thể tạo video đầu ra tại: {output_video_path}")
    cap.release()
    exit()

# Đọc và xử lý video với tracking
frame_count = 0  # Frame trong video đếm từ 0
while cap.isOpened():
    ret, frame = cap.read()
    if not ret:
        print("✅ Hoàn tất video hoặc lỗi khi đọc frame.")
        break

    json_frame_idx = frame_count + 1  # JSON đánh số từ 1, video từ 0

    # Vẽ bounding box nếu có track tại frame này
    if json_frame_idx in frame_to_tracks:
        for track_info in frame_to_tracks[json_frame_idx]:
            track_id = track_info["track_id"]
            x, y, w, h = track_info["box"]

            # Kiểm tra nếu bbox hoàn toàn ngoài khung hình
            if x >= width or y >= height or x + w <= 0 or y + h <= 0:
                print(f"⚠ Lỗi bbox (Track {track_id}): {x, y, w, h}, Frame: {json_frame_idx}")
                continue  # Bỏ qua bbox này

            # Lấy màu cho track
            color = track_colors.get(track_id, (0, 255, 0))  # Màu sắc ngẫu nhiên cho mỗi track

            # Vẽ bbox hợp lệ
            cv2.rectangle(frame, (x, y), (x + w, y + h), color, 2)
            cv2.putText(frame, f"Track {track_id[:8]}", (x, y - 10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, color, 2)

    # Thêm số frame vào góc video
    cv2.putText(frame, f"Frame: {json_frame_idx}", (10, 30),
                cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 255), 2)

    # Ghi frame vào video đầu ra
    out.write(frame)

    frame_count += 1

# Giải phóng tài nguyên
cap.release()
out.release()
print(f"🎉 Video đã được lưu tại: {output_video_path}")
