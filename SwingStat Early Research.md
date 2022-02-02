# SwingStat Early Research
## January 31 

### Questions

- What 3D tracking functionality is there within the MediaPipe BlazePose library? 
	- Do we have access to rotation around the spine and spine tilt information?
- How do we normalize the posture information for a golf swing to allow model building AND swing to swing comparison?

### Notes

- MediaPipe’s BlazePose powers Google’s ML Kit’s Pose Detection API
	- Two different SDK’s:
		- ML Kit Pose Detection (https://developers.google.com/ml-kit/vision/pose-detection)
			- iOS Podfile 
				- Native/Swift
					- **Pros:**
						- Fast, native, first party access to device resources/capabilities
					- **Cons:**
						- I like Swift - do y’all?
							- *Backend can still be node.js/express/Mongo stack or whatever we want. Create serverless API *
				- 

			- Android Maven Library
				- Kotlin/Java
					- **Pros:**
						- Eh
					- **Cons:**
						- Only Android……

		- BlazePose (https://google.github.io/mediapipe/solutions/pose.html)
			- **No first party React Native support**

				- Provide web JS demo but not full featured
			- Offers first party desktop support but not exactly what we’re looking for 
- Posture Model
	- ‘Virtruvian man’ represents the human body
		- One point determined representing the center of the hips
		- One point, for determining direction, above the head on the circle made by the arms and legs extended
	- Lite/Full/Heavy model variants w/ increasing latency AND accuracy
		- For our use case, we want maximum accuracy - NOT REAL TIME
	- 2D vs 3D points
		- BlazePose provides two sets of pose landmarks:
			- pose_landmarks
				- X, Y, Z coordinate landmarks normalized to [0.0, 1.0] by the image height and width pose
			- pose_world_landmarks
				- X, Y, Z coords in ***real-world meters ***

		- MLKit Swift API
			- PoseLandmark.getPosition()
				- X,Y coord from [0.0, 1.0]
			- PoseLandmark.getPosition3D()
				- X, Y, Z coordinate from [0.0, 1.0]
					- Z coordinate represents the center of the subject’s hips 
						- Negative if closer to the camera, positive if further away
		- We *may *need to use the MediaPipe implementation to have access to the real-world meters coordinates to allow normalizing?
			- Not sure….

- ML Kit example of training pose classification model
	- **Demonstrates normalizing the pose coordinates from absolutes to allow comparison and model training **
		- **https://developers.google.com/ml-kit/vision/pose-detection/classifying-poses**
- ML Kit Swift/Android example for manual angle heuristics and other pose analysis/recognition heuristics
	- https://developers.google.com/ml-kit/vision/pose-detection/classifying-poses

	- Will need to build out system to ‘detect’ certain key events in the golf swing to then extract that frame (or batch of frames) to calculate desired angles 
		- Top of backswing
		- Set up at ball
		- Contact position
- *****Useful example of overall detection/tracking process & basic video labeling with Python API **
	- **https://bleedai.com/introduction-to-pose-detection-and-basic-pose-classification/**
- Python API for object detection
	- Python API for the MediaPipe Object Detection Solution

	- 

### Ideas

- Combine swing coordinate representations from multiple angles, taking averages to reduce error
	- Potentially require front, behind view, synthesize together and store user’s swing 
		- Combine (avg, or something) the different angle’s posture coordinates and THEN draw the coordinates on the desired swing angle
			- Should improve accuracy ?
- Use Object Detection & box tracking (MediaPipe) to find the club head & track it
	- Estimate clubhead speed & impact angle to ultimately predict shot distance 
	- https://medium.com/analytics-vidhya/mediapipe-object-detection-and-box-tracking-82926abc50c2

![SwingStat Early Research](images/SwingStat%20Early%20Research.png)


