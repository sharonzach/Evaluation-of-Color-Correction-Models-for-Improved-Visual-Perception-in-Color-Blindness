function simulate_and_correct_using_veinot_model()

    [filename, filepath] = uigetfile({'*.jpg;*.jpeg;*.png;*.bmp', 'Image Files (*.jpg, *.jpeg, *.png, *.bmp)'}, 'Select an Image');
  
    if isequal(filename, 0)
        disp('User canceled the image selection.');
        return;
    end
    img = imread(fullfile(filepath, filename));

    if size(img, 3) ~= 3
        error('The selected image must be a color image (RGB).');
    end
    
    rgb = double(img) / 255;

    veinot_matrices.deuteranopia = [0.367, 0.861, -0.228; 
                                    0.280, 0.673, 0.047; 
                                    -0.012, 0.042, 0.970];
    veinot_matrices.protanopia = [0.152, 0.867, -0.019; 
                                  0.178, 0.723, 0.099; 
                                  0.022, 0.140, 0.838];
    veinot_matrices.tritanopia = [0.950, 0.050, 0; 
                                  0, 0.433, 0.567; 
                                  0, 0.475, 0.525];

    correction_matrices.deuteranopia = [1.5, 0, 0; 0, 1, 0; 0, 0, 1];
    correction_matrices.protanopia = [1.3, 0, 0; 0, 1.1, 0; 0, 0, 1];
    correction_matrices.tritanopia = [1, 0, 0; 0, 1.2, 0; 0, 0, 1.4];

    color_deficit = menu('Select the Color Deficiency Type', 'Deuteranopia', 'Protanopia', 'Tritanopia');
    
    switch color_deficit
        case 1
            color_deficit = 'deuteranopia';
        case 2
            color_deficit = 'protanopia';
        case 3
            color_deficit = 'tritanopia';
        otherwise
            disp('No color deficit type selected.');
            return;
    end

    simulated_rgb = apply_veinot_model(rgb, veinot_matrices.(color_deficit));

    corrected_rgb = apply_color_correction(simulated_rgb, correction_matrices.(color_deficit));

    mse_sim = immse(simulated_rgb, rgb);
    ssim_sim = ssim(simulated_rgb, rgb);
    mse_corr = immse(corrected_rgb, rgb);
    ssim_corr = ssim(corrected_rgb, rgb);

    fprintf('Simulated Image MSE: %.4f, SSIM: %.4f\n', mse_sim, ssim_sim);
    fprintf('Corrected Image MSE: %.4f, SSIM: %.4f\n', mse_corr, ssim_corr);

    figure('Name', 'Veinot Color Blindness Simulation and Correction', 'NumberTitle', 'off');
    subplot(1, 3, 1);
    imshow(rgb);
    title('Original Image');
    
    subplot(1, 3, 2);
    imshow(simulated_rgb);
    title(['Simulated Image (' color_deficit ')']);
    
    subplot(1, 3, 3);
    imshow(corrected_rgb);
    title(['Corrected Image (' color_deficit ')']);
end

function simulated_rgb = apply_veinot_model(rgb, transform_matrix)
   
    [m, n, ~] = size(rgb);
    img_reshaped = reshape(rgb, m * n, 3);
    simulated_img = img_reshaped * transform_matrix';
    simulated_rgb = reshape(simulated_img, m, n, 3);
    simulated_rgb = min(max(simulated_rgb, 0), 1);
end

function corrected_rgb = apply_color_correction(simulated_rgb, correction_matrix)
    [m, n, ~] = size(simulated_rgb);
    img_reshaped = reshape(simulated_rgb, m * n, 3);
    corrected_img = img_reshaped * correction_matrix';
    corrected_rgb = reshape(corrected_img, m, n, 3);
    corrected_rgb = min(max(corrected_rgb, 0), 1);
end
