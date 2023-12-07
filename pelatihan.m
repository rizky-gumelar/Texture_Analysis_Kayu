clc; clear; close all; warning off all;

%menetapkan nama folder
nama_folder = 'data latih baru';
%membaca nama file yang berekstensi .jpg
nama_file = dir(fullfile(nama_folder,'*.jpg'));
%membaca jumlah file yang berekstensi .jpg
jumlah_file = numel(nama_file);
%inisialisasi variable data_latih
data_latih = zeros(jumlah_file,4);

%melakukan pengolahan citra terhadap seluruh file
for k = 1:jumlah_file
    %membaca file citra rgb
    Img = imread(fullfile(nama_folder,nama_file(k).name));
    %figure, imshow(Img);
    
    % conversi rgb to gray
    gray = rgb2gray(Img);
    Img_gray = imsharpen(gray);
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
    data_latih(k,1) = contrast;
    data_latih(k,2) = correlation;
    data_latih(k,3) = energy;
    data_latih(k,4) = homogeneity;
    
end

%menetapkan terget uji
target_latih = cell(jumlah_file,1);
for k = 1:15
    target_latih{k} = 'Jati';
end

for k = 16:30
    target_latih{k} = 'Mahoni';
end

%PEMBENTUKAN MODEL SVM
Mdl = fitcsvm(data_latih, target_latih);

%membaaca kelas keluaran hasil pelatihan
kelas_keluaran = predict(Mdl, data_latih);

%menghitung akurasi pelatihan 
jumlah_benar = 0;
for k=1:jumlah_file
    if isequal(kelas_keluaran{k},target_latih{k})
        jumlah_benar = jumlah_benar+1;
    end
end

akurasi_pelatihan = jumlah_benar/jumlah_file*100

save Mdl Mdl
