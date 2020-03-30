%%
clear all;
addpath(pwd + "\Utility");

%% QPSK
seIdxSetAll = {}; nPrbSetAll = {}; snrdBSetAll = {};
cbBlerListSetAll = {}; tbBlerListSetAll = {};
fileNameList = ["SampleData\DynErr\blerMatQPSK_PRB1.mat" "SampleData\DynErr\blerMatQPSK_PRB2.mat"...
                "SampleData\DynErr\blerMatQPSK_PRB5.mat" "SampleData\DynErr\blerMatQPSK_PRB10.mat"...
                "SampleData\DynErr\blerMatQPSK_PRB20.mat" "SampleData\DynErr\blerMatQPSK_PRB50.mat"...
                "SampleData\DynErr\blerMatQPSK_PRB100.mat" ...
                "SampleData\ConstErr\blerMatQPSK_PRB10.mat" "SampleData\ConstErr\blerMatQPSK_PRB15.mat"...
                "SampleData\ConstErr\blerMatQPSK_PRB20.mat" "SampleData\ConstErr\blerMatQPSK_PRB25.mat"...
                "SampleData\ConstErr\blerMatQPSK_PRB30.mat" "SampleData\ConstErr\blerMatQPSK_PRB40.mat"...
                "SampleData\ConstErr\blerMatQPSK_PRB50.mat" "SampleData\ConstErr\blerMatQPSK_PRB70.mat"];
cntItem = 0;
for fileIdx = 1:size(fileNameList, 2)
    theFileName = fileNameList(fileIdx);
    load(theFileName, 'snrdB_List', 'nPrb', 'cbBlerMatrix', 'tbBlerMatrix');
    for seIdx = 1:16
        cntItem = cntItem + 1;
        seIdxSetAll{cntItem} = seIdx; nPrbSetAll{cntItem} = nPrb; snrdBSetAll{cntItem} = snrdB_List;
        cbBlerListSetAll{cntItem} = cbBlerMatrix(seIdx, :); tbBlerListSetAll{cntItem} = tbBlerMatrix(seIdx, :);
    end
end

fileNameList = ["SampleData\BGN1_NCB1.mat" "SampleData\BGN1_NCB2.mat"...
                "SampleData\BGN2_NCB1.mat" "SampleData\BGN2_NCB2.mat"];
for fileIdx = 1:size(fileNameList, 2)
    theFileName = fileNameList(fileIdx); load(theFileName);
    for itemIdx = 1:size(seIdxSet, 2)
        seIdx = seIdxSet{itemIdx}; nPrb = nPrbSet{itemIdx}; 
        if seIdx > 16
            continue;
        end
        cntItem = cntItem + 1;
        seIdxSetAll{cntItem} = seIdx; nPrbSetAll{cntItem} = nPrb; snrdBSetAll{cntItem} = snrdB_List;
        cbBlerListSetAll{cntItem} = cbBlerListSet{itemIdx}; tbBlerListSetAll{cntItem} = tbBlerListSet{itemIdx};
    end
end

theFileName = "SampleData\testData_SE12_CB1.mat"; startPRBIdx = 1; endPRBIdx = 15; seIdx = 12;
load(theFileName, 'snrdB_List', 'testPRB_list', 'cbBlerMatrix', 'tbBlerMatrix');
for prbIdx = startPRBIdx:endPRBIdx
    cntItem = cntItem + 1;
    seIdxSetAll{cntItem} = seIdx; nPrbSetAll{cntItem} = testPRB_list(prbIdx); snrdBSetAll{cntItem} = snrdB_List;
    cbBlerListSetAll{cntItem} = cbBlerMatrix(prbIdx, :); tbBlerListSetAll{cntItem} = cbBlerMatrix(prbIdx, :);
end

theFileName = "SampleData\testData_SE12.mat"; startPRBIdx = 1; endPRBIdx = 18; seIdx = 12;
load(theFileName, 'snrdB_List', 'testPRB_list', 'cbBlerMatrix', 'tbBlerMatrix');
for prbIdx = startPRBIdx:endPRBIdx
    cntItem = cntItem + 1;
    seIdxSetAll{cntItem} = seIdx; nPrbSetAll{cntItem} = testPRB_list(prbIdx); snrdBSetAll{cntItem} = snrdB_List;
    cbBlerListSetAll{cntItem} = cbBlerMatrix(prbIdx, :); tbBlerListSetAll{cntItem} = cbBlerMatrix(prbIdx, :);
end

save("QPSKSampleSet.mat", 'seIdxSetAll', 'nPrbSetAll', 'snrdBSetAll', 'cbBlerListSetAll', 'tbBlerListSetAll');

%% 16QAM
seIdxSetAll = {}; nPrbSetAll = {}; snrdBSetAll = {};
cbBlerListSetAll = {}; tbBlerListSetAll = {};

fileNameList = ["SampleData\DynErr\blerMat16QAM_PRB5.mat" "SampleData\DynErr\blerMat16QAM_PRB10.mat"...
                "SampleData\DynErr\blerMat16QAM_PRB20.mat" "SampleData\DynErr\blerMat16QAM_PRB50.mat"...
                "SampleData\ConstErr\blerMat16QAM_PRB10.mat" "SampleData\ConstErr\blerMat16QAM_PRB15.mat"...
                "SampleData\ConstErr\blerMat16QAM_PRB20.mat" "SampleData\ConstErr\blerMat16QAM_PRB30.mat"...
                "SampleData\ConstErr\blerMat16QAM_PRB50.mat"];
cntItem = 0;
for fileIdx = 1:size(fileNameList, 2)
    theFileName = fileNameList(fileIdx);
    load(theFileName, 'snrdB_List', 'nPrb', 'cbBlerMatrix', 'tbBlerMatrix');
    for seIdx = 17:23
        cntItem = cntItem + 1;
        seIdxSetAll{cntItem} = seIdx; nPrbSetAll{cntItem} = nPrb; snrdBSetAll{cntItem} = snrdB_List;
        cbBlerListSetAll{cntItem} = cbBlerMatrix(seIdx, :); tbBlerListSetAll{cntItem} = tbBlerMatrix(seIdx, :);
    end
end

fileNameList = ["SampleData\BGN1_NCB1.mat" "SampleData\BGN1_NCB2.mat"...
                "SampleData\BGN2_NCB1.mat" "SampleData\BGN2_NCB2.mat"];
for fileIdx = 1:size(fileNameList, 2)
    theFileName = fileNameList(fileIdx);
    load(theFileName);
    for itemIdx = 1:size(seIdxSet, 2)
        seIdx = seIdxSet{itemIdx}; nPrb = nPrbSet{itemIdx}; 
        if (seIdx < 17 || seIdx > 23)
            continue;
        end
        cntItem = cntItem + 1;
        seIdxSetAll{cntItem} = seIdx; nPrbSetAll{cntItem} = nPrb; snrdBSetAll{cntItem} = snrdB_List;
        cbBlerListSetAll{cntItem} = cbBlerListSet{itemIdx}; tbBlerListSetAll{cntItem} = tbBlerListSet{itemIdx};
    end
end

save("16QAMSampleSet.mat", 'seIdxSetAll', 'nPrbSetAll', 'snrdBSetAll', 'cbBlerListSetAll', 'tbBlerListSetAll');

%% 64QAM
seIdxSetAll = {}; nPrbSetAll = {}; snrdBSetAll = {};
cbBlerListSetAll = {}; tbBlerListSetAll = {};

fileNameList = ["SampleData\DynErr\blerMat64QAM_PRB10.mat"...
                "SampleData\ConstErr\blerMat64QAM_PRB5.mat" "SampleData\ConstErr\blerMat64QAM_PRB10.mat"...
                "SampleData\ConstErr\blerMat64QAM_PRB15.mat" "SampleData\ConstErr\blerMat64QAM_PRB20.mat"...
                "SampleData\ConstErr\blerMat64QAM_PRB30.mat" "SampleData\ConstErr\blerMat64QAM_PRB50.mat"];
cntItem = 0;
for fileIdx = 1:size(fileNameList, 2)
    theFileName = fileNameList(fileIdx);
    load(theFileName, 'snrdB_List', 'nPrb', 'cbBlerMatrix', 'tbBlerMatrix');
    for seIdx = 24:35
        cntItem = cntItem + 1;
        seIdxSetAll{cntItem} = seIdx; nPrbSetAll{cntItem} = nPrb; snrdBSetAll{cntItem} = snrdB_List;
        cbBlerListSetAll{cntItem} = cbBlerMatrix(seIdx, :); tbBlerListSetAll{cntItem} = tbBlerMatrix(seIdx, :);
    end
end

fileNameList = ["SampleData\BGN1_NCB1.mat" "SampleData\BGN1_NCB2.mat"...
                "SampleData\BGN2_NCB1.mat" "SampleData\BGN2_NCB2.mat"];
for fileIdx = 1:size(fileNameList, 2)
    theFileName = fileNameList(fileIdx);
    load(theFileName);
    for itemIdx = 1:size(seIdxSet, 2)
        seIdx = seIdxSet{itemIdx}; nPrb = nPrbSet{itemIdx}; 
        if (seIdx < 24 || seIdx > 35)
            continue;
        end
        cntItem = cntItem + 1;
        seIdxSetAll{cntItem} = seIdx; nPrbSetAll{cntItem} = nPrb; snrdBSetAll{cntItem} = snrdB_List;
        cbBlerListSetAll{cntItem} = cbBlerListSet{itemIdx}; tbBlerListSetAll{cntItem} = tbBlerListSet{itemIdx};
    end
end

save("64QAMSampleSet.mat", 'seIdxSetAll', 'nPrbSetAll', 'snrdBSetAll', 'cbBlerListSetAll', 'tbBlerListSetAll');


%% 256QAM
seIdxSetAll = {}; nPrbSetAll = {}; snrdBSetAll = {};
cbBlerListSetAll = {}; tbBlerListSetAll = {};

fileNameList = ["SampleData\DynErr\blerMat256QAM_PRB1.mat" "SampleData\DynErr\blerMat256QAM_PRB2.mat"...
                "SampleData\DynErr\blerMat256QAM_PRB4.mat" "SampleData\DynErr\blerMat256QAM_PRB5.mat"...
                "SampleData\DynErr\blerMat256QAM_PRB8.mat" "SampleData\DynErr\blerMat256QAM_PRB10.mat"];
cntItem = 0;
for fileIdx = 1:size(fileNameList, 2)
    theFileName = fileNameList(fileIdx);
    load(theFileName, 'snrdB_List', 'nPrb', 'cbBlerMatrix', 'tbBlerMatrix');
    for seIdx = 36:43
        cntItem = cntItem + 1;
        seIdxSetAll{cntItem} = seIdx; nPrbSetAll{cntItem} = nPrb; snrdBSetAll{cntItem} = snrdB_List;
        cbBlerListSetAll{cntItem} = cbBlerMatrix(seIdx, :); tbBlerListSetAll{cntItem} = tbBlerMatrix(seIdx, :);
    end
end

fileNameList = ["SampleData\BGN1_NCB1.mat" "SampleData\BGN1_NCB2.mat"...
                "SampleData\BGN2_NCB1.mat" "SampleData\BGN2_NCB2.mat"];
for fileIdx = 1:size(fileNameList, 2)
    theFileName = fileNameList(fileIdx);
    load(theFileName);
    for itemIdx = 1:size(seIdxSet, 2)
        seIdx = seIdxSet{itemIdx}; nPrb = nPrbSet{itemIdx}; 
        if (seIdx < 36)
            continue;
        end
        cntItem = cntItem + 1;
        seIdxSetAll{cntItem} = seIdx; nPrbSetAll{cntItem} = nPrb; snrdBSetAll{cntItem} = snrdB_List;
        cbBlerListSetAll{cntItem} = cbBlerListSet{itemIdx}; tbBlerListSetAll{cntItem} = tbBlerListSet{itemIdx};
    end
end

save("256QAMSampleSet.mat", 'seIdxSetAll', 'nPrbSetAll', 'snrdBSetAll', 'cbBlerListSetAll', 'tbBlerListSetAll');

