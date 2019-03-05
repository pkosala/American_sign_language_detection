clear all;
%this script will take input from ass3_input, apply PCA and get the
%required final input matrix to be used for classification
no_of_features = 552;
no_of_components = 50;
no_of_groups = 37;
keySet =   ["ABOUT","AND","CAN","COP","DEAF","DECIDE","FATHER","FIND","GOOUT","HEARING"];
d = pwd;
% first create the PCA matrix for all the gestures 
% for each gesture, go through each group; and get the combined matrix
% combined for 37 groups, and apply PCA

for gesture = 1 : 10
    initial_feature_matrix = zeros(1, no_of_features);
    rows_per_group = zeros(1, no_of_groups);
    
    %create a feature matrix for a gesture for all groups
    for group = 1 : no_of_groups
        
        %get the folder name
        if group < 10
            folder_name = ['ass3_input/', 'DM0', int2str(group), '/'];
        else
            folder_name = ['ass3_input/', 'DM', int2str(group), '/'];
        end
        
        table_name = ['transformed_', char(strcat(lower(string(keySet(gesture))), ".csv"))];
        T = readtable([folder_name, table_name]);
        t1 = table2array(T);
        
        rows_per_group(group) = size(t1, 1);
        initial_feature_matrix = [initial_feature_matrix; t1];
  
    end
    initial_feature_matrix = initial_feature_matrix(2:end, :);
    
    disp(['Initial Feature Matrix generated for ', table_name]);
    % apply pca to whole feature matrix
    
    [coeff, pca_matrix, latent] = pca(initial_feature_matrix);
    
    final_pca_matrix = pca_matrix(:, 1 : no_of_components);
    
    % now again separate the data into groups and add to folder PCA_outputs
    cursor = 1;
    for group = 1 : no_of_groups
        
        %get the folder name
        if group < 10
            if ~exist([d,'\pca_output\','DM0',int2str(group)], 'dir')
                mkdir([d,'\pca_output\'],['DM0',int2str(group)]);
            end
            folder_name = ['pca_output\', 'DM0', int2str(group), '\'];
        else
            if ~exist([d,'\pca_output\','DM',int2str(group)], 'dir')
                mkdir([d,'\pca_output\'],['DM',int2str(group)]);
            end
            folder_name = ['pca_output\', 'DM', int2str(group), '\'];
        end
        
        extracted_group_matrix = final_pca_matrix(cursor : cursor + rows_per_group(group) - 1, :);
        cursor = cursor + rows_per_group(group);
        
        % write extracted group matrix to appropiate folder here
        csvwrite([folder_name, table_name], extracted_group_matrix);
    end
    disp(['PCA completed for ', table_name]);
    
end
