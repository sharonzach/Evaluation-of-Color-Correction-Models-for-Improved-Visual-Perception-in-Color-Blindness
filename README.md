# Color-correction-for-color-blind-people-using-daltonisation-methods-in-MATLAB
This project provides a MATLAB implementation for simulating color blindness and applying daltonization to improve color perception for color-deficient individuals. The tool supports three types of color blindness: Deuteranopia, Protanopia, and Tritanopia.

Features
Load Image: Select and load an image from your local system.
Simulate Color Blindness: Generate a version of the image as perceived by color-deficient individuals.
Daltonization: Enhance the image to make it more distinguishable for color-blind users, with adjustable intensity.
User-Friendly GUI: Includes an interactive slider to adjust the daltonization intensity in real-time.

Prerequisites
MATLAB: R2021a or newer is recommended.
Toolboxes: None required (uses standard MATLAB functions).
Image Files: Any color image in .jpg, .jpeg, .png, or .bmp formats.

How to Use
Clone the repository:
git clone https://github.com/your-username/color-blindness-simulation.git
cd color-blindness-simulation
Open MATLAB and navigate to the project directory.

Run the main function:

matlab
Copy code
simulate_and_daltonize
Follow these steps in the GUI:

1. Select an image file when prompted.
2. Choose the type of color blindness to simulate: Deuteranopia, Protanopia, or Tritanopia.
3. Adjust the Daltonization Intensity slider to apply corrections and enhance the image.
   
Example Workflow
Original Image: Load an RGB image from your system.
Simulate Color Blindness: View the image as perceived by individuals with a specific type of color blindness.
Daltonized Image: Use the slider to adjust the intensity of the daltonization effect, making colors more distinguishable for color-blind users.

Functions Overview
1. simulate_and_daltonize: Main script for selecting an image and running the GUI.
2. simulate_color_blindness: Simulates color blindness by applying transformations to the LMS color space.
3. daltonize_image: Enhances the image using the calculated error from the simulation to apply color corrections.
4. transform_colorspace: Helper function to convert between RGB, LMS, and other color spaces.
5. updateDaltonization: Callback function for the slider to update the daltonized image in real-time.
   
Future Enhancements
Add support for batch processing of images.
Integrate additional algorithms for more accurate daltonization.
Save daltonized images for external use.
Extend to handle videos for real-time applications.
