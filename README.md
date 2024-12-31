# Visibility Enhancement for Color Blind Individuals

This project presents a comparative analysis of three methods for enhancing visibility for individuals with color blindness: **Daltonization**, **Veinot Correction**, and **Wavelet-Based Correction**. The methods are tested using a random image, with performance evaluated through **Mean Squared Error (MSE)** and **Structural Similarity Index (SSIM)** metrics.



## Overview
Color blindness affects millions of individuals globally, reducing their ability to perceive colors accurately. This MATLAB project implements and compares three correction techniques to enhance the visual experience for people with different types of color vision deficiencies (Deuteranopia, Protanopia, Tritanopia). 

By applying these techniques, this project provides insights into improving accessibility for the color-blind community.

---

## Features
- Simulates color blindness for three common types:
  - **Deuteranopia** (Red-Green blindness)
  - **Protanopia** (Red deficiency)
  - **Tritanopia** (Blue-Yellow blindness)
- Implements three correction techniques:
  1. **Daltonization**: Adjusts colors for better perception by simulating and correcting color blindness.
  2. **Veinot Correction**: Applies specific transformation and correction matrices.
  3. **Wavelet-Based Correction**: Enhances visibility by modifying wavelet coefficients.
- Provides side-by-side visual comparisons:
  - Original Image
  - Simulated Image
  - Corrected Image
- Quantitative evaluation using:
  - **MSE**: Measures pixel-wise differences between original and corrected images.
  - **SSIM**: Evaluates perceptual similarity.

---

## Methods

### 1. Daltonization
Simulates color blindness by transforming the color space using pre-defined matrices. A correction step then adjusts colors for improved visibility.

### 2. Veinot Correction
Uses scientific models with specific transformation and correction matrices tailored for each type of color blindness. 

### 3. Wavelet-Based Correction
Applies wavelet decomposition to modify and enhance specific frequency components, improving contrast and color differentiation.

---

## Evaluation
- **Mean Squared Error (MSE)**: Lower values indicate closer resemblance to the original image.
- **Structural Similarity Index (SSIM)**: Higher values represent better perceptual similarity.

The results are displayed in a GUI, showcasing the MSE and SSIM values alongside visual comparisons of the images.

Clone the repository:
   ```bash
   git clone https://github.com/yourusername/visibility-enhancement-color-blind.git
   cd visibility-enhancement-color-blind
```
Open MATLAB.

Install required toolboxes (Image Processing Toolbox).

Run the desired script to test the correction methods.
System Requirements
1. MATLAB (tested on R2023a or newer)
2. Image Processing Toolbox
3. Compatible with Windows, macOS, and Linux.

Project Structure
```
visibility-enhancement-color-blind/
├── daltonisation.m            # Daltonization method implementation
├── veinot.m               # Veinot correction method implementation
├── wavelet.m             # Wavelet-based correction method implementation
├── README.md              # Project documentation
```
