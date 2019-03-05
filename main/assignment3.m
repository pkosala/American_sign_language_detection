for i = 1:37
    if i<10
        convertDataToCSV(['0',num2str(i)]);
        main(['0',num2str(i)]);
    else
        convertDataToCSV(num2str(i));
        main(num2str(i));
    end
end