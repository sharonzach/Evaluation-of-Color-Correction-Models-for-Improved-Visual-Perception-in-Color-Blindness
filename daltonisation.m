function simulate_and_daltonize()

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
    
    rgb2lms = [0.3904725, 0.54990437, 0.00890159; 
               0.07092586, 0.96310739, 0.00135809; 
               0.02314268, 0.12801221, 0.93605194];
    lms2rgb = [2.85831110, -1.62870796, -0.0248186967; 
               -0.210434776, 1.15841493, 3.20463334e-04; 
               -0.0418895045, -0.118154333, 1.06888657];

    cb_matrices.d = [1, 0, 0; 1.10104433, 0, -0.00901975; 0, 0, 1];
    cb_matrices.p = [0, 0.90822864, 0.008192; 0, 1, 0; 0, 0, 1];
    cb_matrices.t = [1, 0, 0; 0, 1, 0; -0.15773032, 1.19465634, 0];
    color_deficit = menu('Select the Color Deficiency Type', 'Deuteranopia', 'Protanopia', 'Tritanopia');
    
    switch color_deficit
        case 1
            color_deficit = 'd'; % Deuteranopia
        case 2
            color_deficit = 'p'; % Protanopia
        case 3
            color_deficit = 't'; % Tritanopia
        otherwise
            disp('No color deficit type selected.');
            return;
    end

    simulated_rgb = simulate_color_blindness(rgb, cb_matrices, rgb2lms, lms2rgb, color_deficit);

    f = figure('Name', 'Color Blindness Simulation', 'NumberTitle', 'off');
    subplot(1, 3, 1);
    imshow(rgb);
    title('Original Image');
    
    subplot(1, 3, 2);
    imshow(simulated_rgb);
    title('Simulated Color Blindness');

    % Add a slider for daltonization intensity
    uicontrol('Style', 'text', 'String', 'Daltonization Intensity', 'Position', [20 20 200 20]);
    slider = uicontrol('Style', 'slider', 'Min', 0, 'Max', 1, 'Value', 0.5, ...
        'Position', [20 50 200 20], 'Callback', @(src, event) updateDaltonization(src, rgb, simulated_rgb, cb_matrices, rgb2lms, lms2rgb, color_deficit, f));

end

function updateDaltonization(slider, rgb, simulated_rgb, cb_matrices, rgb2lms, lms2rgb, color_deficit, f)
   
    intensity = slider.Value;
    
    daltonized_rgb = daltonize_image(rgb, simulated_rgb, cb_matrices, rgb2lms, lms2rgb, color_deficit, intensity);

    subplot(1, 3, 3);
    imshow(daltonized_rgb);
    title('Daltonized Image');

    % Result analysis
    calculate_metrics(rgb, simulated_rgb, daltonized_rgb);
end

function calculate_metrics(original, simulated, daltonized)
    % Mean Squared Error
    mse_sim = mean((original(:) - simulated(:)).^2);
    mse_dal = mean((original(:) - daltonized(:)).^2);

    % Structural Similarity Index (SSIM)
    ssim_sim = ssim(simulated, original);
    ssim_dal = ssim(daltonized, original);

    % Print results
    fprintf('Analysis of Results:\n');
    fprintf('MSE (Simulated): %.4f\n', mse_sim);
    fprintf('MSE (Daltonized): %.4f\n', mse_dal);
    fprintf('SSIM (Simulated): %.4f\n', ssim_sim);
    fprintf('SSIM (Daltonized): %.4f\n', ssim_dal);
end

function simulated_rgb = simulate_color_blindness(rgb, cb_matrices, rgb2lms, lms2rgb, color_deficit)
    
    lms = transform_colorspace(rgb, rgb2lms);
    
    sim_lms = transform_colorspace(lms, cb_matrices.(color_deficit));
    
    simulated_rgb = transform_colorspace(sim_lms, lms2rgb);
    
    simulated_rgb = min(max(simulated_rgb, 0), 1);
end

function daltonized_rgb = daltonize_image(rgb, simulated_rgb, cb_matrices, rgb2lms, lms2rgb, color_deficit, intensity)
    
    err = rgb - simulated_rgb;
    err2mod = [0, 0, 0; 0.7, 1, 0; 0.7, 0, 1];
    modified_err = transform_colorspace(err, err2mod) * intensity;
    daltonized_rgb = rgb + modified_err;
    daltonized_rgb = min(max(daltonized_rgb, 0), 1);
end

function transformed_img = transform_colorspace(img, mat)
    [m, n, ~] = size(img);
    img_reshaped = reshape(img, m * n, 3);
    transformed_img = img_reshaped * mat';
    transformed_img = reshape(transformed_img, m, n, 3);
end
