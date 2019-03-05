function [] = accuracy_plots4(ges,accuracy,precision,recall,f1_score)


figure('Name',ges);
x = categorical({'DM11','DM12','DM13','DM15','DM16','DM18','DM19','DM20',...
    'DM21','DM22','DM23','DM24','DM25','DM26','DM27','DM28','DM29','DM30','DM31',...
    'DM32','DM33','DM34','DM35','DM36','DM37'});

subplot(4,1,1);
bar(x,accuracy);
xlabel('Users');
ylabel('Accuracy');

subplot(4,1,2);
bar(x,precision);
xlabel('Users');
ylabel('Precision');

subplot(4,1,3);
bar(x,recall);
xlabel('Users');
ylabel('Recall');

subplot(4,1,4);
bar(x,f1_score);
xlabel('Users');
ylabel('F1 score');