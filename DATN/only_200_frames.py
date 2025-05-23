# import json
# import os
# import cv2
# import random
# from collections import defaultdict

# def process_json(input_json_path, output_json_path, max_frame=200):
#     """
#     Process JSON to keep only frames 1 to max_frame and remove invalid bounding boxes.
#     """
#     # Read input JSON
#     try:
#         with open(input_json_path, 'r') as f:
#             data = json.load(f)
#     except Exception as e:
#         print(f"Error reading input JSON: {e}")
#         return None
    
#     # Process each object
#     for obj_id in data:
#         frames = data[obj_id]['frames']
#         boxes = data[obj_id]['boxes']
        
#         valid_indices = []
#         for i, (frame_path, box) in enumerate(zip(frames, boxes)):
#             # Extract frame number
#             filename = os.path.basename(frame_path)
#             try:
#                 frame_num = int(filename.split('.')[0])
#             except ValueError:
#                 print(f"Invalid frame path format: {frame_path}")
#                 continue
            
#             # Check if frame is within range (1 to max_frame)
#             if frame_num > max_frame:
#                 continue
            
#             # Validate bounding box (1280x720, no negative coordinates, valid size)
#             x, y, w, h = box
#             is_valid = (
#                 x >= 0 and y >= 0 and w > 0 and h > 0 and
#                 x + w <= 1280 and y + h <= 720
#             )
            
#             if is_valid:
#                 valid_indices.append(i)
#             else:
#                 print(f"Removed invalid bbox for object {obj_id}, frame {frame_num}: {box}")
        
#         # Update frames and boxes
#         data[obj_id]['frames'] = [frames[i] for i in valid_indices]
#         data[obj_id]['boxes'] = [boxes[i] for i in valid_indices]
        
#         # If no boxes remain, set empty arrays
#         if not data[obj_id]['boxes']:
#             data[obj_id]['frames'] = []
#             data[obj_id]['boxes'] = []
    
#     # Custom JSON serialization
#     def custom_json_dumps(data):
#         lines = []
#         lines.append('{')
#         for obj_id, obj_data in data.items():
#             lines.append(f'  "{obj_id}": {{')
#             lines.append('    "frames": [')
#             for i, frame in enumerate(obj_data['frames']):
#                 comma = ',' if i < len(obj_data['frames']) - 1 else ''
#                 lines.append(f'      "{frame}"{comma}')
#             lines.append('    ],')
#             lines.append('    "boxes": [')
#             for i, box in enumerate(obj_data['boxes']):
#                 comma = ',' if i < len(obj_data['boxes']) - 1 else ''
#                 lines.append(f'      {json.dumps(box, separators=(",", ","))}{comma}')
#             lines.append('    ]')
#             lines.append('  },' if obj_id != list(data.keys())[-1] else '  }')
#         lines.append('}')
#         return '\n'.join(lines)
    
#     # Write output JSON
#     try:
#         with open(output_json_path, 'w') as f:
#             f.write(custom_json_dumps(data))
#         print(f"✅ Modified JSON saved to: {output_json_path}")
#         return data
#     except Exception as e:
#         print(f"Error writing output JSON: {e}")
#         return None

# def create_video(video_path, json_data, output_video_path, max_frame=200):
#     """
#     Create a video from frames 1 to max_frame using processed JSON data.
#     """
#     # Create frame-to-tracks mapping
#     frame_to_tracks = defaultdict(list)
#     track_colors = {}
    
#     for track_id, track_data in json_data.items():
#         frames = track_data["frames"]
#         boxes = track_data["boxes"]
        
#         track_colors[track_id] = (random.randint(0, 255), random.randint(0, 255), random.randint(0, 255))
        
#         for frame_path, box in zip(frames, boxes):
#             frame_name = os.path.basename(frame_path)
#             frame_idx = int(frame_name.split(".")[0])
#             if frame_idx > max_frame:
#                 continue
#             frame_to_tracks[frame_idx].append({
#                 "track_id": track_id,
#                 "box": box
#             })
    
#     # Open video
#     cap = cv2.VideoCapture(video_path)
#     if not cap.isOpened():
#         print(f"❌ Cannot open video: {video_path}")
#         return
    
#     # Get video properties
#     fps = cap.get(cv2.CAP_PROP_FPS)
#     width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
#     height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
#     print(f"🎥 Video FPS: {fps}, Size: {width}x{height}")
    
#     # Setup output video
#     fourcc = cv2.VideoWriter_fourcc(*'mp4v')
#     out = cv2.VideoWriter(output_video_path, fourcc, fps, (width, height))
#     if not out.isOpened():
#         print(f"❌ Cannot create output video at: {output_video_path}")
#         cap.release()
#         return
    
#     # Process frames
#     frame_count = 0
#     while cap.isOpened() and frame_count < max_frame:
#         ret, frame = cap.read()
#         if not ret:
#             print(f"✅ End of video or error at frame {frame_count}")
#             break
        
#         json_frame_idx = frame_count + 1
        
#         # Draw bounding boxes
#         if json_frame_idx in frame_to_tracks:
#             for track_info in frame_to_tracks[json_frame_idx]:
#                 track_id = track_info["track_id"]
#                 x, y, w, h = track_info["box"]
                
#                 # Adjust bbox to fit within frame
#                 x = max(0, x)
#                 y = max(0, y)
#                 x2 = min(x + w, width)
#                 y2 = min(y + h, height)
                
#                 if x2 > x and y2 > y:
#                     color = track_colors.get(track_id, (0, 255, 0))
#                     cv2.rectangle(frame, (x, y), (x2, y2), color, 2)
#                     cv2.putText(frame, f"Track {track_id[:8]}", (x, y - 10),
#                                 cv2.FONT_HERSHEY_SIMPLEX, 0.5, color, 2)
        
#         # Add frame number
#         cv2.putText(frame, f"Frame: {json_frame_idx}", (10, 30),
#                     cv2.FONT_HERSHEY_SIMPLEX, 1, (255, 255, 255), 2)
        
#         # Write frame to output video
#         out.write(frame)
        
#         frame_count += 1
    
#     # Release resources
#     cap.release()
#     out.release()
#     print(f"🎉 Video saved to: {output_video_path}")

# if __name__ == "__main__":
#     # Hardcoded paths
#     input_json_path = r"E:\Lab\Tracking\AIC22\train\S01\c002\output\output.json"
#     output_json_path = r"E:\Lab\Tracking\AIC22\train\S01\c002\output\modified_output.json"
#     video_path = r"E:\Lab\Tracking\AIC22\train\S01\c002\vdo.mp4"
#     output_video_path = r"E:\Lab\Tracking\AIC22\train\S01\c002\visualized_1_to_200.mp4"
    
#     # Process JSON (keep frames 1 to 200, remove invalid bboxes)
#     json_data = process_json(input_json_path, output_json_path, max_frame=200)
    
#     # Create video if JSON processing was successful
#     if json_data:
#         create_video(video_path, json_data, output_video_path, max_frame=200)

import json
import os

def process_json(input_json_path, output_json_path, max_frame=200):
    """
    Process JSON to keep only frames 1 to max_frame and remove invalid bounding boxes.
    """
    # Read input JSON
    try:
        with open(input_json_path, 'r') as f:
            data = json.load(f)
    except Exception as e:
        print(f"Error reading input JSON: {e}")
        return None
    
    # Process each object
    for obj_id in data:
        frames = data[obj_id]['frames']
        boxes = data[obj_id]['boxes']
        
        valid_indices = []
        for i, (frame_path, box) in enumerate(zip(frames, boxes)):
            # Extract frame number
            filename = os.path.basename(frame_path)
            try:
                frame_num = int(filename.split('.')[0])
            except ValueError:
                print(f"Invalid frame path format: {frame_path}")
                continue
            
            # Check if frame is within range (1 to max_frame)
            if frame_num > max_frame:
                continue
            
            # Validate bounding box (1280x720, no negative coordinates, valid size)
            x, y, w, h = box
            is_valid = (
                x >= 0 and y >= 0 and w > 0 and h > 0 and
                x + w <= 1280 and y + h <= 720
            )
            
            if is_valid:
                valid_indices.append(i)
            else:
                print(f"Removed invalid bbox for object {obj_id}, frame {frame_num}: {box}")
        
        # Update frames and boxes
        data[obj_id]['frames'] = [frames[i] for i in valid_indices]
        data[obj_id]['boxes'] = [boxes[i] for i in valid_indices]
        
        # If no boxes remain, set empty arrays
        if not data[obj_id]['boxes']:
            data[obj_id]['frames'] = []
            data[obj_id]['boxes'] = []
    
    # Custom JSON serialization
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
        return data
    except Exception as e:
        print(f"Error writing output JSON: {e}")
        return None

if __name__ == "__main__":
    # Hardcoded paths
    input_json_path = r"C:\Users\Lenovo\Downloads\full.json"
    output_json_path = r"C:\Users\Lenovo\Downloads\full_200_frames.json"
    
    # Process JSON (keep frames 1 to 200, remove invalid bboxes)
    process_json(input_json_path, output_json_path, max_frame=200)