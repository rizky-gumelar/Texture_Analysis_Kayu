clc; clear; close all; warning off all;

% memanggil menu "browse file"
[nama_file, nama_folder] = uigetfile('*.jpg');

% jika ada nama file yang dipilih maka akan mengeksekusi perintah
if ~isequal(nama_file,0)
    %membaca file citra rgb
    Img = imread(fullfile(nama_folder,nama_file));
    %figure, imshow(Img);
    
    % conversi rgb to gray
    Img_gray = rgb2gray(Img);
    
    %ekstraksi ciri GLCM
    pixel_dist = 1; %jarak antar filter
    
    % membentuk matriks konkurensi
    GLCM = graycomatrix(Img_gray,'Offset',[0 pixel_dist;...
        -pixel_dist pixel_dist; -pixel_dist 0; -pixel_dist -pixel_dist]);

    %mengekstrak fitur GLCM
    stats = graycoprops(GLCM,{'Contrast','Correlation','Energy','Homogeneity'});

    contrast = mean(stats.Contrast);
    correlation = mean(stats.Correlation);
    energy = mean(stats.Energy);
    homogeneity = mean(stats.Homogeneity);
    
    % menyusun variable data_uji
    data_uji(1,1) = contrast;
    data_uji(1,2) = correlation;
    data_uji(1,3) = energy;
    data_uji(1,4) = homogeneity;
    
    %MEMANGGIL MODEL SVM HASIL PELATIHAN
    load Mdl

    %membaaca kelas keluaran hasil pengujian
    kelas_keluaran = predict(Mdl, data_uji);
    
    %menampilkan citra asli dan kelas keluaran  hasil pengujian
    figure
    imshow (imresize(Img,0.5))
    title({['Nama File: ',nama_file],['Kelas Keluaran: ',kelas_keluaran{1}]});
else
    %jika tidak ada nama file yang dipilih maka akan kembali
    return
end

    
