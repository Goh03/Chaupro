import os
import cv2


def extract_frames(video_path, output_dir):
    os.makedirs(output_dir, exist_ok=True)
    cap = cv2.VideoCapture(video_path)
    if not cap.isOpened():
        print(f"❌ Cannot open {video_path}")
        return

    count = 1
    success, frame = cap.read()
    while success:
        img_path = os.path.join(output_dir, f"{count:06d}.jpg")
        cv2.imwrite(img_path, frame)
        print(f"✅ Extracted {img_path}")
        count += 1
        success, frame = cap.read()

    cap.release()


def walk_and_extract(root_dir):
    for root, _, files in os.walk(root_dir):
        for file in files:
            if file == "vdo.mp4":
                video_path = os.path.join(root, file)
                output_path = os.path.join(root, "img1")
                extract_frames(video_path, output_path)


if __name__ == "__main__":
    train_root = r"E:\Lab\Tracking\AIC22\train"
    val_root = r"E:\Lab\Tracking\AIC22\validation"

    walk_and_extract(train_root)
    walk_and_extract(val_root)

    print("🎉 Done extracting all videos.")
