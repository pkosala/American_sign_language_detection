no_of_components = 50;
gesture_name =   ["about","and","can","cop","deaf","decide","father","find","hearing"];
d = pwd;
base_path = [d, '\main\'];
no_of_groups = 10;
csv_names = ["training.csv", "testing.csv"];

for gesture = 1 : 9
        ffm = zeros(1, no_of_components + 1);
        for group = 1 : no_of_groups
            %first get the total number of rows for the input matrix
            folder_name = [base_path, 'assignment_4\classification_input_2\', char(gesture_name(gesture)), '\', 'DM', int2str(group), '\'];
            for csv_idx = 1:2
                T = readtable([folder_name, char(csv_names(csv_idx))]);
                t1 = table2array(T);
                ffm = [ffm ; t1];
            end
        end
        ffm = ffm(2:end, :);
        final_csv_path = [base_path, 'assignment_4\ass4_input\training\', char(gesture_name(gesture)), '.csv'];
        csvwrite(final_csv_path, ffm);
        disp(['completed training for gesture ', char(gesture_name(gesture))]);
end

test_groups = [11:13,15,16,18:37];
%create neccessary directiories
for t1 = test_groups
    group_folder = [base_path, '\assignment_4\ass4_input\testing\DM', int2str(t1)];
    if ~exist(group_folder, 'dir')
        mkdir(group_folder);
    end
end

for gesture = 1 : 9
    ffm = zeros(1, no_of_components + 1);
    for group = test_groups
        folder_name = [base_path, 'assignment_4\classification_input\', char(gesture_name(gesture)), '\', 'DM', int2str(group), '\'];
        for csv_idx = 1 : 2
            T = readtable([folder_name, char(csv_names(csv_idx))]);
            t1 = table2array(T);
            ffm = [ffm ; t1];
        end
        ffm = ffm(2:end, :);
        final_csv_path = [base_path, 'assignment_4\ass4_input\testing\DM', int2str(group), '\', char(gesture_name(gesture)), '.csv'];
        csvwrite(final_csv_path, ffm);
    end
    disp(['completed training for gesture ', char(gesture_name(gesture))]);
end