import os
import shutil

# Đường dẫn
label_root = r"E:\Lab\Tracking\AIC22\Yolo_label\train\S01\c004\img1"  # Chỉ xử lý thư mục cụ thể
img_root = r"E:\Lab\Tracking\AIC22\train\S01\c004\img1"  # Thư mục ảnh tương ứng
output_yolo_dir = r"E:\Lab\Tracking\AIC22\Yolo"
output_img_dir = os.path.join(output_yolo_dir, "img")
output_label_dir = os.path.join(output_yolo_dir, "label")

# Danh sách định dạng ảnh hỗ trợ
IMG_EXTENSIONS = (".jpg", ".jpeg", ".png")

def validate_label_file(label_path):
    """Kiểm tra file nhãn có hợp lệ không, trả về lý do nếu không hợp lệ"""
    try:
        with open(label_path, "r", encoding="utf-8") as f:
            lines = f.readlines()
            if not lines:
                return False, "File rỗng"
            for line in lines:
                line = line.strip()
                if not line:
                    continue  # Bỏ qua dòng trống
                parts = line.split()
                if len(parts) < 5:
                    return False, f"Không đủ 5 phần tử: {line}"
                # Kiểm tra class là số nguyên
                if not parts[0].isdigit():
                    return False, f"Class không phải số nguyên: {parts[0]}"
                # Kiểm tra các giá trị khác là số hợp lệ
                try:
                    for val in parts[1:]:
                        float_val = float(val)
                        if not 0 <= float_val <= 1:  # Kiểm tra giá trị trong [0, 1]
                            return False, f"Giá trị ngoài khoảng [0, 1]: {val}"
                except ValueError:
                    return False, f"Giá trị không phải số: {line}"
            return True, ""
    except Exception as e:
        return False, f"Lỗi đọc file: {str(e)}"

def process_train_dataset():
    missing_files = []
    invalid_labels = []

    # Duyệt file nhãn trong thư mục cụ thể
    label_files = [
        os.path.join(root, file)
        for root, _, files in os.walk(label_root)
        for file in files
        if file.endswith(".txt")
    ]

    for label_path in label_files:
        # Kiểm tra file nhãn
        is_valid, reason = validate_label_file(label_path)
        if not is_valid:
            invalid_labels.append((label_path, reason))
            continue

        # Tính đường dẫn tương đối
        rel_path = os.path.relpath(label_path, label_root)
        img_found = False

        # Tìm ảnh với các định dạng hỗ trợ
        for ext in IMG_EXTENSIONS:
            img_path = os.path.join(img_root, rel_path.replace(".txt", ext))
            if os.path.exists(img_path):
                # Đường dẫn đích
                img_save_path = os.path.join(output_img_dir, rel_path.replace(".txt", ext))
                label_save_path = os.path.join(output_label_dir, rel_path)

                # Tạo thư mục đích
                os.makedirs(os.path.dirname(img_save_path), exist_ok=True)
                os.makedirs(os.path.dirname(label_save_path), exist_ok=True)

                # Sao chép file
                shutil.copy2(img_path, img_save_path)
                shutil.copy2(label_path, label_save_path)
                img_found = True
                break

        if not img_found:
            missing_files.append(img_path)

    # Báo cáo lỗi
    if missing_files:
        print(f"⚠️ Không tìm thấy {len(missing_files)} ảnh:")
        for f in missing_files[:5]:  # In tối đa 5 file
            print(f"  - {f}")
    if invalid_labels:
        print(f"⚠️ Tìm thấy {len(invalid_labels)} file nhãn không hợp lệ:")
        for path, reason in invalid_labels[:5]:
            print(f"  - {path}: {reason}")

# Xử lý tập train
process_train_dataset()
print("✅ Hoàn tất chuẩn bị dữ liệu.")