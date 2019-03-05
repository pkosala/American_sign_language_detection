function [] = convertDataToCSV(user_no)
d = pwd;
if exist('raw_input')
    cd('raw_input');
end
% array for all gestures
ges = {'about','and','can','cat','cop','cost','day',...
    'deaf','decide','father','find','gold','night',...
    'go out','hearing','here','hospital','hurt','if',...
    'large'};
% all groups folders
% files = dir;
% loop for all gestures
for g = 1:length(ges)
    ges_trim = strrep(ges{g},' ','');
    mkdir([d,'\ass2_output\'],['DM',user_no]);
    if exist([d,'\ass2_output\DM',user_no,'\',ges_trim,'.csv'])
        delete([d,'\ass2_output\DM',user_no,'\',ges_trim,'.csv'])
    end
    f_main = fopen([d,'\ass2_output\DM',user_no,'\',ges_trim,'.csv'],'a');
%     loop for all group folders
%     for ii = 1:length(files)
%         if ~strcmp(files(ii).name,'.') && ~strcmp(files(ii).name,'..')
            cd(['DM',user_no]);
            csv = {};
            all = dir;
            for tt = 1:length(all)
                all_lower = lower(all(tt).name);
                temp = regexp(all_lower,ges{g});
                if ~isempty(temp)
                    csv{end+1} = all(tt).name;
                end
            end
            n = 0;
%             loop for all csv of a particular gesture
            for m = 1:length(csv)
                n = n + 1;
                fid = fopen(csv{m});
                data = textscan(fid,'%s');
                data_arr = strings(50,34);
                if length(data{1}) <50
                    l = length(data{1});
                else
                    l = 49;
                end
                for h = 1:l
                    ts = ['Action_',num2str(n)];
                    a = regexp(data{1}{h},',','split');
                    for hh = 1:34
                        data_arr(1,hh) = string(mat2cell(ts,1));
                    end
                    for hh = 1:34
                        data_arr(h+1,hh) = a{1,hh};
                    end
                end
                for h = length(data{1})+1:50
                    for hh = 1:34
                        data_arr(h,hh) = '0';
                    end
                end
%                 transpose of the data array
                data_arr = data_arr';
%                 loops for printing the data in the gesture csv
                for h = 1:size(data_arr,1)
                    for k = 1:size(data_arr,2)
                        if k == size(data_arr,2)
                            fprintf(f_main,'%s\n',data_arr(h,k));
                        else
                            fprintf(f_main,'%s,',data_arr(h,k));
                        end
                    end
                end
                fclose(fid);
            end
            cd('..');
%         end
%     end
    
    fclose all;
end
cd('..');