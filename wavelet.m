function color_correction_simple()
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
    cb_matrices.d = [1, 0, 0; 1.10104433, 0, -0.00901975; 0, 0, 1];  % Deuteranopia
    cb_matrices.p = [0, 0.90822864, 0.008192; 0, 1, 0; 0, 0, 1];  % Protanopia
    cb_matrices.t = [1, 0, 0; 0, 1, 0; -0.15773032, 1.19465634, 0];  % Tritanopia

    color_deficit = menu('Select the Color Deficiency Type', 'Deuteranopia', 'Protanopia', 'Tritanopia');
    if color_deficit == 0
        disp('No color deficit type selected.');
        return;
    end
    deficit_types = ['d', 'p', 't'];
    deficit_type = deficit_types(color_deficit);
    lms = transform_colorspace(rgb, rgb2lms());
    sim_lms = transform_colorspace(lms, cb_matrices.(deficit_type));
    simulated_rgb = transform_colorspace(sim_lms, lms2rgb());
    daltonized_rgb = daltonize(simulated_rgb, rgb);
    [ssim_sim, ~] = ssim(simulated_rgb, rgb);  % SSIM between original and simulated
    [ssim_daltonized, ~] = ssim(daltonized_rgb, rgb);  % SSIM between original and daltonized
    mse_sim = immse(simulated_rgb, rgb);  % MSE between original and simulated
    mse_daltonized = immse(daltonized_rgb, rgb);  % MSE between original and daltonized

    figure;
    subplot(1, 3, 1); imshow(rgb); title('Original Image');
    subplot(1, 3, 2); imshow(simulated_rgb); title(['Simulated Color Blindness (SSIM=', num2str(ssim_sim, 2), ', MSE=', num2str(mse_sim, 2), ')']);
    subplot(1, 3, 3); imshow(daltonized_rgb); title(['Daltonized Image (SSIM=', num2str(ssim_daltonized, 2), ', MSE=', num2str(mse_daltonized, 2), ')']);

    fprintf('SSIM between original and simulated: %.4f\n', ssim_sim);
    fprintf('SSIM between original and daltonized: %.4f\n', ssim_daltonized);
    fprintf('MSE between original and simulated: %.4f\n', mse_sim);
    fprintf('MSE between original and daltonized: %.4f\n', mse_daltonized);
end
function rgb2lms = rgb2lms()
    rgb2lms = [0.3904725, 0.54990437, 0.00890159;
               0.07092586, 0.96310739, 0.00135809;
               0.02314268, 0.12801221, 0.93605194];
end

function lms2rgb = lms2rgb()
    lms2rgb = [2.85831110, -1.62870796, -0.0248186967;
               -0.210434776, 1.15841493, 3.20463334e-04;
               -0.0418895045, -0.118154333, 1.06888657];
end
function transformed_img = transform_colorspace(img, mat)
    [m, n, ~] = size(img);
    img_reshaped = reshape(img, m * n, 3);
    transformed_img = img_reshaped * mat';
    transformed_img = reshape(transformed_img, m, n, 3);
end
function daltonized_img = daltonize(simulated_rgb, original_rgb)
    daltonized_img = simulated_rgb;  % Modify this logic to apply a color correction method
    % Example: simple scaling based on similarity to original
    daltonized_img = simulated_rgb + 0.5 * (original_rgb - simulated_rgb);
end
