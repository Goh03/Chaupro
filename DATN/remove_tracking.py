import json
import os

def remove_invalid_bboxes(input_json_path, output_json_path, object_id=None, start_frame=None, end_frame=None):
    """
    Remove invalid bounding boxes (negative coordinates or outside 1280x720) and optionally
    remove frames for a specific object ID between given frames.
    
    Args:
        input_json_path: Path to input JSON file
        output_json_path: Path to output JSON file
        object_id: ID of the object to modify (string, optional)
        start_frame: Starting frame number to remove (inclusive, optional)
        end_frame: Ending frame number to remove (inclusive, optional)
    """
    # Read input JSON
    try:
        with open(input_json_path, 'r') as f:
            data = json.load(f)
    except Exception as e:
        print(f"Error reading input JSON: {e}")
        return
    
    # Process each object in the JSON
    for obj_id in data:
        # Skip if specific object_id is provided and doesn't match
        if object_id is not None and obj_id != object_id:
            continue
        
        frames = data[obj_id]['frames']
        boxes = data[obj_id]['boxes']
        
        # Extract frame numbers and validate bounding boxes
        valid_indices = []
        for i, (frame_path, box) in enumerate(zip(frames, boxes)):
            # Extract frame number
            filename = os.path.basename(frame_path)
            try:
                frame_num = int(filename.split('.')[0])
            except ValueError:
                print(f"Invalid frame path format: {frame_path}")
                continue
            
            # Validate bounding box (1280x720, no negative coordinates, valid size)
            x, y, w, h = box
            is_valid = (
                x >= 0 and y >= 0 and w > 0 and h > 0 and
                x + w <= 1280 and y + h <= 720
            )
            
            # Check if frame is within removal range (if specified)
            in_removal_range = (
                start_frame is not None and end_frame is not None and
                start_frame <= frame_num <= end_frame
            )
            
            # Keep the index if bbox is valid and not in removal range
            if is_valid and not in_removal_range:
                valid_indices.append(i)
            else:
                print(f"Removed bbox for object {obj_id}, frame {frame_num}: {box} (Valid: {is_valid}, In range: {in_removal_range})")
        
        # Update frames and boxes to keep only valid ones
        data[obj_id]['frames'] = [frames[i] for i in valid_indices]
        data[obj_id]['boxes'] = [boxes[i] for i in valid_indices]
        
        # If no boxes remain, set empty arrays
        if not data[obj_id]['boxes']:
            data[obj_id]['frames'] = []
            data[obj_id]['boxes'] = []
    
    # Custom JSON serialization to format boxes as single-line arrays
    def custom_json_dumps(data):
        lines = []
        lines.append('{')
        for obj_id, obj_data in data.items():
            lines.append(f'  "{obj_id}": {{')
            lines.append('    "frames": [')
            for i, frame in enumerate(obj_data['frames']):
                comma = ',' if i < len(obj_data['frames']) - 1 else ''
                lines.append(f'      "{frame}"{comma}')
            lines.append('    ],')
            lines.append('    "boxes": [')
            for i, box in enumerate(obj_data['boxes']):
                comma = ',' if i < len(obj_data['boxes']) - 1 else ''
                lines.append(f'      {json.dumps(box, separators=(",", ","))}{comma}')
            lines.append('    ]')
            lines.append('  },' if obj_id != list(data.keys())[-1] else '  }')
        lines.append('}')
        return '\n'.join(lines)
    
    # Write output JSON
    try:
        with open(output_json_path, 'w') as f:
            f.write(custom_json_dumps(data))
        print(f"✅ Modified JSON saved to: {output_json_path}")
    except Exception as e:
        print(f"Error writing output JSON: {e}")

if __name__ == "__main__":
    # Hardcoded paths for running directly
    input_path = r"C:\Users\Lenovo\Downloads\X.json"
    output_path = r"C:\Users\Lenovo\Downloads\X.json"
    # output_path = r"E:\Lab\Tracking\AIC22\train\S01\c002\output\modified_output.json"
    
    # Remove invalid bboxes for all objects
    remove_invalid_bboxes(input_path, output_path, object_id="116", start_frame=1, end_frame=254)
    
    # Example to remove frames for a specific object (uncomment to use)
    # remove_invalid_bboxes(input_path, output_path, object_id="98", start_frame=170, end_frame=192)