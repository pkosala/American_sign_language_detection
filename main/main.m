function [] = main(user_no)
fclose all;
d = pwd;
keySet =   ["ABOUT","AND","CAN","COP","DEAF","DECIDE","FATHER","FIND","GOOUT","HEARING"];
% valueSet = {["ARZ", "ARY", "ARX", "GRZ", "GRX","ORR","EMG0R","EMG1R","EMG2R","EMG3R","EMG4R","EMG5R","EMG6R","EMG7R"]
% ["ARX", "GRZ", "GRX","ORR","EMG0R","EMG1R","EMG2R","EMG3R","EMG4R","EMG5R","EMG6R","EMG7R"]
% ["ARZ","ALZ","GRX","GLX","ORL","ORR","OPR","OPL","EMG0R","EMG1R","EMG2R","EMG3R","EMG4R","EMG5R","EMG6R","EMG7R","EMG0L","EMG1L","EMG2L","EMG3L","EMG4L","EMG5L","EMG6L","EMG7L"]
% ["ARY","ARX","GRX","OPR","OYR","ORR","EMG0R","EMG1R","EMG2R","EMG3R","EMG4R","EMG5R","EMG6R","EMG7R"]
% ["ARZ","ARY","ARX","GRX","GRY","GRZ","OYR","EMG0R","EMG1R","EMG2R","EMG3R","EMG4R","EMG5R","EMG6R","EMG7R"]
% ["ARZ","ALZ","ARY","ALY","GRX","GLX","ORL","OPL","ORR","OPR"]
% ["ARX","ARZ","GRX","EMG0R","EMG1R","EMG2R","EMG3R","EMG4R","EMG5R","EMG6R","EMG7R"]
% ["ARZ","ARY","GRX","ORR","EMG0R","EMG1R","EMG2R","EMG3R","EMG4R","EMG5R","EMG6R","EMG7R"]
% ["ARY","ARX","GRX","GRY","ORR","OPR","EMG0R","EMG1R","EMG2R","EMG3R","EMG4R","EMG5R","EMG6R","EMG7R"]
% ["ARY","ARZ","GRX","EMG0R","EMG1R","EMG2R","EMG3R","EMG4R","EMG5R","EMG6R","EMG7R"]};
% valueSet = {'EMG0R','EMG1R','EMG2R','EMG3R','EMG4R','EMG5R','EMG6R','EMG7R','GRZ','GRX','ORR','OPR','ARY','ARZ','ARX'};
% valueSet = {'ALX','ALY','ALZ','ARX','ARY','ARZ','EMG0L','EMG1L','EMG2L','EMG0R','EMG1R','EMG2R','EMG3R','GLX','GLY','GLZ','GRX','GRY','GRZ','ORL','OPL','OYL','ORR','OPR','OYR'};

cd(['ass2_output\DM',user_no]);
for t1 = 1 : length(keySet)
    valueSet = {'GLX','GLY','GLZ','GRX','GRY','GRZ','EMG0L','EMG0R','ALX','ALY','OYR','ORR'};
%     valueSet = {'GLX','EMG0L','ALX','OYR'};
    index = [1 2 3 4 5 6 7 8 9 10 11 12];




    mapObj = containers.Map(valueSet,index);
    
    table_name = strcat(lower(string(keySet(t1))), ".csv");
    T = readtable(table_name);

    %gesture_name = 'ABOUT';
    %sensors = mapObj(gesture_name);
    values_per_sensors = 46;
    final_mat = zeros(height(T)/34, values_per_sensors*length(valueSet));
    arr_to_add = zeros(1,values_per_sensors*length(valueSet));
    %arr_to_add = [];
    final_row = 1;
    stats_arr = zeros(1,5);
    for i = 1 : height(T)
        sensor_name = string(T(i, :).Var2);
        for j = 1 : length(valueSet)
            if strcmp(valueSet{j}, sensor_name)
                %call functions here on row
                row = table2array(T(i, 3:50));

                fft_arr = fft(row);
                fft_arr = abs(fft_arr);
                fft_indexes = ceil(linspace(1, 48, 10));
                fft_arr = fft_arr(fft_indexes); %sam's idea to take 10

                [c, l] = wavedec(row,3,'db2');
                approx_level_3 = appcoef(c,l,'db2', 3);
                [cd1,cd2,cd3] = detcoef(c,l,[1 2 3]);
                dwt_arr = [approx_level_3 cd3];
                              
                [stats_arr(1),stats_arr(2),stats_arr(3),stats_arr(4),stats_arr(5)] = stats(row);
                stats_arr = abs(stats_arr);

                autocor_arr = autocorr(row);
                autocor_arr = abs(autocor_arr);
                
                if isnan(autocor_arr(1))
                    row(1) = row(1) + 0.00000001;
                end
                autocor_arr = autocorr(row);
                autocor_arr = abs(autocor_arr);
                
                autocorr_indexes = ceil(linspace(1, 21, 10));
                autocor_arr = autocor_arr(autocorr_indexes);
                
                windowed_mean_arr = windowed_mean(row);
                ind = mapObj(valueSet{j});
                arr_to_add(values_per_sensors*(ind - 1)+1:values_per_sensors*(ind - 1)+values_per_sensors) = [fft_arr dwt_arr stats_arr autocor_arr windowed_mean_arr];   

            end
        end
        if rem(i, 34) == 2
            if length(arr_to_add) ~= values_per_sensors*length(valueSet)
                disp('error');
                arr_to_add = zeros(1,values_per_sensors*length(valueSet));
            else
                final_mat(final_row, :) = arr_to_add;
                final_row = final_row + 1;
                arr_to_add = zeros(1,values_per_sensors*length(valueSet));
            end
        end
    end

    % final_mat to csv
    mkdir([d,'\ass3_input\'],['DM',user_no]);
    csvwrite(strcat(d,'\ass3_input\DM',user_no,'\','transformed_', table_name), final_mat);
    disp(char(['Done for transformed_', table_name]));
end
cd('..');
cd('..');