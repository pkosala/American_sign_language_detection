function [] = tree_classifier()
clear all;
warning off;
d = pwd;

if exist('tree_accuracy_log.csv')
    delete('tree_accuracy_log.csv');
end
fid = fopen('tree_accuracy_log.csv','a');
fprintf(fid,'%s\n','Group,Gesture,Accuracy,Precision,Recall,F1 score');
if exist('classification_input_2')
    cd('classification_input_2');
end

ges = {'about','and','can','cop','deaf','decide','father','find','hearing'};

num_of_groups = 37;
for i = 1 : length(ges)
    cd(ges{i});
    accuracy = [];
    precision = [];
    recall = [];
    f1_score = [];
    for j = 1 : num_of_groups
        if j == 14 || j == 17
            continue;
        end
        cd(['DM',num2str(j)]);
        training_table = readtable('training.csv');
        training_arr = table2array(training_table);
        if ~isempty(training_arr)
            tree = fitctree(training_table(:,1:size(training_arr,2)-1),training_table(:,size(training_arr,2)),'MaxNumSplits',7,'CrossVal','on');
            testing_table = readtable('testing.csv');
            testing_arr = table2array(testing_table);
            correct_pos = 0;
            correct_neg = 0;
            pos_cnt = 0;
            neg_cnt = 0;
            for k = 1 : size(testing_arr,1)
                if testing_arr(k,size(testing_arr,2)) == 1
                    pos_cnt = pos_cnt + 1;
                else
                    neg_cnt = neg_cnt + 1;
                end
            end

            for k = 1 : size(testing_arr,1)
                if (predict(tree.Trained{1},testing_arr(k,1:size(testing_arr,2)-1)) == testing_arr(k,size(testing_arr,2)))
                    if testing_arr(k,size(testing_arr,2)) == 1
                        correct_pos = correct_pos + 1;
                    else
                        correct_neg = correct_neg + 1;
                    end
                end
            end
        
            accuracy = [accuracy,((correct_neg + correct_pos)/(neg_cnt + pos_cnt)) * 100];
            precision = [precision,correct_pos/(correct_pos +  (neg_cnt - correct_neg)) * 100];
            recall = [recall,(correct_pos/pos_cnt) * 100];
            f1_score = [f1_score,2*(precision(end) * recall(end))/(precision(end) + recall(end))];
            fprintf(fid,'%s\n',['DM',num2str(j),',',ges{i},',',num2str(accuracy(end)),',',num2str(precision(end)),',',num2str(recall(end)),',',num2str(f1_score(end))]);
        end
        cd('..');
    end
    accuracy_plots(j,ges{i},accuracy,precision,recall,f1_score);
    cd('..');
    disp([ges{i},' done']);
end
cd('..');
fclose(fid);
save('model.mat','tree');