clc;
clear;
close all;

% 1. 生成256x256的PHANTOM圖像
image_size = 256;  % 圖像大小
phantom_image = phantom('Modified Shepp-Logan', image_size);  % 使用MATLAB的phantom函數

% 顯示原始PHANTOM圖像
figure;
imshow(phantom_image, []);
title('Original Phantom Image'); % 原始Phantom圖像

% 2. 進行2D Fourier變換得到K-space數據並顯示
k_space = fftshift(fft2(phantom_image));  % 計算K-space（頻域數據）

% 顯示K-space的幅值
figure;
imshow(log(abs(k_space) + 1), []);  % 使用對數尺度增強對比度
title('K-space Magnitude (Log Scale)'); % K-space幅值（對數尺度）

% 3. 調整K-space的實部和虛部的權重，觀察偽影
% 獲取K-space的實部和虛部
real_part = real(k_space);
imag_part = imag(k_space);

% 定義權重
weight_real = 1;  % 實部的權重
weight_imag = 1;  % 虛部的權重（可以調整以觀察偽影變化）

% 調整K-space的實部和虛部權重
adjusted_k_space = weight_real * real_part + 1i * weight_imag * imag_part;

% 對調整後的K-space數據進行逆Fourier變換，重建圖像
reconstructed_image = ifft2(ifftshift(adjusted_k_space));

% 顯示調整後的重建圖像
figure;
imshow(abs(reconstructed_image), []);
title(['Reconstructed Image (Weight Real = ', num2str(weight_real), ...
       ', Weight Imag = ', num2str(weight_imag), ')']); % 重建圖像標題

% 4. 測試不同的虛部權重以觀察偽影變化
figure;
weight_imag_values = [0.2, 0.5, 0.8, 1.0];  % 虛部權重的不同設置
for i = 1:length(weight_imag_values)
    % 調整K-space
    weight_imag = weight_imag_values(i);
    adjusted_k_space = weight_real * real_part + 1i * weight_imag * imag_part;

    % 重建圖像
    reconstructed_image = ifft2(ifftshift(adjusted_k_space));

    % 顯示圖像
    subplot(2, 2, i);
    imshow(abs(reconstructed_image), []);
    title(['Weight Imag = ', num2str(weight_imag)]); % 顯示虛部權重的標題
end

% 5. 測試不同的實部權重以觀察偽影變化 
figure;
weight_real_values = [0.2, 0.5, 0.8, 1.0];  % 實部權重的不同設置
for i = 1:length(weight_real_values)
    % 調整K-space
    weight_real = weight_real_values(i);
    adjusted_k_space = weight_real * real_part + 1i * weight_imag * imag_part;

    % 重建圖像
    reconstructed_image = ifft2(ifftshift(adjusted_k_space));

    % 顯示圖像
    subplot(2, 2, i);
    imshow(abs(reconstructed_image), []);
    title(['Weight Real = ', num2str(weight_real)]); % 顯示實部權重的標題
end
