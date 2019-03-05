
no_of_components = 50;
training_ratio = 0.6;
testing_ratio = 0.4;
keySet =   ["ABOUT","AND","CAN","COP","DEAF","DECIDE","FATHER","FIND","GOOUT","HEARING"];
d = pwd;
no_of_groups = 37;
input_type = 3;

if input_type == 1
    disp("Input Type 1");
    for positive_gesture = 1 : 10
        for group = 1 : no_of_groups
            % all data structures
            all_tables = {};


            %first get the total number of rows for the input matrix
            total_rows = 0;
            for gesture = 1 : 10
                %get the folder name
                if group < 10
                    folder_name = ['pca_output/', 'DM0', int2str(group), '/'];
                else
                    folder_name = ['pca_output/', 'DM', int2str(group), '/'];
                end

                table_name = ['transformed_', char(strcat(lower(string(keySet(gesture))), ".csv"))];
                T = readtable([folder_name, table_name]);
                t1 = table2array(T);
                total_rows = total_rows + size(t1, 1);
                all_tables{gesture} = t1;
            end

            %now loop through all_tables and add its content to
            %final_group_feature_matrix
            final_group_feature_matrix_training = zeros(1, no_of_components+1);
            final_group_feature_matrix_testing = zeros(1, no_of_components+1);

            for gesture = 1 : 10
                gesture_feature_matrix = all_tables{gesture};

                number_of_rows = size(gesture_feature_matrix, 1);

                if positive_gesture == gesture
                    gesture_feature_matrix = [gesture_feature_matrix ones(number_of_rows, 1)];
                else
                    gesture_feature_matrix = [gesture_feature_matrix -1*ones(number_of_rows, 1)];
                end

                t2 = false(number_of_rows, 1);
                t2(1:round(training_ratio*number_of_rows)) = true;
                t2 = t2(randperm(number_of_rows));

                %add to training and testing
                final_group_feature_matrix_training = [final_group_feature_matrix_training; gesture_feature_matrix(t2, :)];
                final_group_feature_matrix_testing = [final_group_feature_matrix_testing; gesture_feature_matrix(~t2, :)];

            end
            % remove the first row containing the zero vector
            final_group_feature_matrix_training = final_group_feature_matrix_training(2:end, :);
            final_group_feature_matrix_testing = final_group_feature_matrix_testing(2:end, :);



            % check for gesture name
            positive_gesture_name = char(lower(string(keySet(positive_gesture))));
            positive_gesture_folder_name = [d,'\classification_input\', positive_gesture_name];

            if ~exist(positive_gesture_folder_name, 'dir')
                 mkdir([d,'\classification_input\'], positive_gesture_name);
            end

            % check for group name
            group_name = [d,'\classification_input\', positive_gesture_name,'\DM',int2str(group)];
            if ~exist(group_name, 'dir')
                 mkdir([d,'\classification_input\', positive_gesture_name], ['\DM',int2str(group)]);
            end

            % write the final_group_feature_matrix here
            table_name = 'training.csv';
            csvwrite([group_name, '\', table_name], final_group_feature_matrix_training);

            table_name = 'testing.csv';
            csvwrite([group_name, '\', table_name], final_group_feature_matrix_testing);
        end
        disp(['Completed for gesture ', positive_gesture_name]);
    end
    
elseif input_type == 2
    disp("Input Type 2");
    for positive_gesture = 1 : 10
        for group = 1 : no_of_groups
            % all data structures
            all_tables = {};


            %first get the total number of rows for the input matrix
            total_rows = 0;
            positive_gesture_rows = 0;
            for gesture = 1 : 10
                %get the folder name
                if group < 10
                    folder_name = ['pca_output/', 'DM0', int2str(group), '/'];
                else
                    folder_name = ['pca_output/', 'DM', int2str(group), '/'];
                end

                table_name = ['transformed_', char(strcat(lower(string(keySet(gesture))), ".csv"))];
                T = readtable([folder_name, table_name]);
                t1 = table2array(T);
                total_rows = total_rows + size(t1, 1);
                all_tables{gesture} = t1;
                if gesture == positive_gesture
                    positive_gesture_rows = size(t1, 1);
                end
                 
            end

            %now loop through all_tables and add its content to
            %final_group_feature_matrix
            final_group_feature_matrix_training = zeros(1, no_of_components+1);
            final_group_feature_matrix_testing = zeros(1, no_of_components+1);
            
            negative_gesture_rows = floor(positive_gesture_rows / 8);
            remainder_rows = mod(positive_gesture_rows, 8);
            
            remainder_flag = true;
            for gesture = 1 : 10
                gesture_feature_matrix = all_tables{gesture};

                number_of_rows = size(gesture_feature_matrix, 1);
                
                if size(gesture_feature_matrix, 1) == 0
                        continue;
                end
                
                if positive_gesture == gesture
                    gesture_feature_matrix = [gesture_feature_matrix ones(number_of_rows, 1)];
                else
                    
                    if remainder_flag == true
                       gesture_feature_matrix = datasample(gesture_feature_matrix, negative_gesture_rows + remainder_rows, 'replace', false);
                       remainder_flag = false;
                    else
                       gesture_feature_matrix = datasample(gesture_feature_matrix, negative_gesture_rows, 'replace', false);
                    end
                    
                    number_of_rows = size(gesture_feature_matrix, 1);
                    
                    gesture_feature_matrix = [gesture_feature_matrix -1*ones(number_of_rows, 1)];
                    
                end

                t2 = false(number_of_rows, 1);
                t2(1:round(training_ratio*number_of_rows)) = true;
                t2 = t2(randperm(number_of_rows));

                %add to training and testing
                final_group_feature_matrix_training = [final_group_feature_matrix_training; gesture_feature_matrix(t2, :)];
                final_group_feature_matrix_testing = [final_group_feature_matrix_testing; gesture_feature_matrix(~t2, :)];

            end
            % remove the first row containing the zero vector
            final_group_feature_matrix_training = final_group_feature_matrix_training(2:end, :);
            final_group_feature_matrix_testing = final_group_feature_matrix_testing(2:end, :);

            
            
            % check for gesture name
            positive_gesture_name = char(lower(string(keySet(positive_gesture))));
            positive_gesture_folder_name = [d,'\classification_input_2\', positive_gesture_name];

            if ~exist(positive_gesture_folder_name, 'dir')
                 mkdir([d,'\classification_input_2\'], positive_gesture_name);
            end

            % check for group name
            group_name = [d,'\classification_input_2\', positive_gesture_name,'\DM',int2str(group)];
            if ~exist(group_name, 'dir')
                 mkdir([d,'\classification_input_2\', positive_gesture_name], ['\DM',int2str(group)]);
            end

            % write the final_group_feature_matrix here
            table_name = 'training.csv';
            csvwrite([group_name, '\', table_name], final_group_feature_matrix_training);

            table_name = 'testing.csv';
            csvwrite([group_name, '\', table_name], final_group_feature_matrix_testing);
        end
        disp(['Completed for gesture ', positive_gesture_name]);
    end
elseif input_type == 3
    for gesture = 1 : 10
        if gesture == 9
            continue;
        end
        gesture_matrix_training = zeros(1, no_of_components + 1);
        gesture_matrix_testing = zeros(1, no_of_components + 1);
        
        for group = 1 : 37
            if group == 17 || group == 14 
                continue;
            end
            folder_name = ['classification_input_2\', char(lower(string(keySet(gesture)))), '/DM', int2str(group),'/'];
            
            t1 = csvread([folder_name, 'training.csv']);
            gesture_matrix_training = [gesture_matrix_training; t1];
            
            t2 = csvread([folder_name, 'testing.csv']);
            gesture_matrix_testing = [gesture_matrix_testing; t2];
        end
        gesture_matrix_training = gesture_matrix_training(2:end, :);
        gesture_matrix_testing = gesture_matrix_testing(2:end, :);
        
        % check for gesture name
        gesture_name = char(lower(string(keySet(gesture))));
        gesture_folder_name = [d,'\classification_input_3\', gesture_name];

        if ~exist(gesture_folder_name, 'dir')
             mkdir([d,'\classification_input_3\'], gesture_name);
        end
        
         % write the final_group_feature_matrix here
        table_name = 'training.csv';
        csvwrite([gesture_folder_name, '\', table_name], gesture_matrix_training);

        table_name = 'testing.csv';
        csvwrite([gesture_folder_name, '\', table_name], gesture_matrix_testing);
        disp(['done for gesture', gesture_name]);
    end
end


