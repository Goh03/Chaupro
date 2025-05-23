import json
import os
from pathlib import Path

def convert_json_format(input_json_path, output_json_path, image_dir="./train/S01/c002/img1", start_frame=1, end_frame=2110):
    """
    Convert JSON from list of detections to object tracking format with object ID as keys.
    Ensures each bounding box is paired with the correct frame's image path and avoids duplicates.
    
    Args:
        input_json_path: Path to input JSON file
        output_json_path: Path to output JSON file
        image_dir: Directory path for images
        start_frame: Starting frame number (for validation)
        end_frame: Ending frame number (for validation)
    """
    # Read input JSON
    try:
        with open(input_json_path, 'r') as f:
            data = json.load(f)
    except (FileNotFoundError, json.JSONDecodeError) as e:
        print(f"Error reading input JSON: {e}")
        return
    
    # Group detections by object ID and frame to avoid duplicates
    tracks = {}
    for detection in data:
        obj_id = detection.get('id')
        if obj_id is None:
            continue
        if obj_id not in tracks:
            tracks[obj_id] = {
                'frames': [],
                'boxes': [],
                'frame_numbers': []
            }
        frame_num = detection.get('frame')
        bbox = detection.get('bbox')
        if frame_num is None or bbox is None:
            continue
        # Validate frame number
        if not (start_frame <= frame_num <= end_frame):
            continue
        # Check for duplicate frame for this object ID
        if frame_num in tracks[obj_id]['frame_numbers']:
            print(f"Warning: Duplicate frame {frame_num} for object ID {obj_id}, keeping last detection")
            idx = tracks[obj_id]['frame_numbers'].index(frame_num)
            tracks[obj_id]['frames'][idx] = f"{image_dir}/{str(frame_num).zfill(6)}.jpg"
            tracks[obj_id]['boxes'][idx] = [
                bbox['x1'],
                bbox['y1'],
                bbox['x2'] - bbox['x1'],
                bbox['y2'] - bbox['y1']
            ]
            continue
        # Convert bbox from {x1,y1,x2,y2} to [x,y,w,h]
        box = [
            bbox['x1'],
            bbox['y1'],
            bbox['x2'] - bbox['x1'],
            bbox['y2'] - bbox['y1']
        ]
        # Store frame and box
        tracks[obj_id]['frame_numbers'].append(frame_num)
        tracks[obj_id]['frames'].append(f"{image_dir}/{str(frame_num).zfill(6)}.jpg")
        tracks[obj_id]['boxes'].append(box)
    
    # Sort frames and boxes by frame number for consistency
    for obj_id in tracks:
        paired = list(zip(tracks[obj_id]['frame_numbers'], tracks[obj_id]['frames'], tracks[obj_id]['boxes']))
        paired.sort(key=lambda x: x[0])
        tracks[obj_id]['frame_numbers'], tracks[obj_id]['frames'], tracks[obj_id]['boxes'] = zip(*paired)
        tracks[obj_id]['frames'] = list(tracks[obj_id]['frames'])
        tracks[obj_id]['boxes'] = list(tracks[obj_id]['boxes'])
        del tracks[obj_id]['frame_numbers']
    
    # Create output structure
    output_data = {}
    for obj_id, track_data in tracks.items():
        output_data[obj_id] = {
            'frames': track_data['frames'],
            'boxes': track_data['boxes']
        }
    
    # Custom JSON serialization to format boxes as single-line arrays
    def custom_json_dumps(data):
        lines = ['{']
        obj_ids = list(data.keys())
        for i, obj_id in enumerate(obj_ids):
            lines.append(f'  "{obj_id}": {{')
            # Frames array
            lines.append('    "frames": [')
            frames = data[obj_id]['frames']
            for j, frame in enumerate(frames):
                comma = ',' if j < len(frames) - 1 else ''
                lines.append(f'      "{frame}"{comma}')
            lines.append('    ],')
            # Boxes array
            lines.append('    "boxes": [')
            boxes = data[obj_id]['boxes']
            for j, box in enumerate(boxes):
                comma = ',' if j < len(boxes) - 1 else ''
                lines.append(f'      {json.dumps(box, separators=(",", ","))}{comma}')
            lines.append('    ]')
            lines.append('  }' + (',' if i < len(obj_ids) - 1 else ''))
        lines.append('}')
        return '\n'.join(lines)
    
    # Write output JSON
    try:
        with open(output_json_path, 'w') as f:
            f.write(custom_json_dumps(output_data))
    except Exception as e:
        print(f"Error writing output JSON: {e}")

if __name__ == "__main__":
    # Example usage
    input_path = r"C:\Users\Lenovo\Downloads\track_results_ocsort_with_appearance (1).json"
    output_path = r"C:\Users\Lenovo\Downloads\track_results_ocsort_with_appearance (1).json"
    convert_json_format(input_path, output_path)