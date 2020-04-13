% test RL-based cost function derivations with the original files generated by PC

% clear all;
clc;
tic;

overwriteFiles = 1;

%% Define internal settings
% Jonathan's Configurations
% configFilePath = '../Data_json/CarrenoConfig/IOC_ExpressiveData_test.json';
% configFilePath = '../Data_json/LinConfig/IOC_IITFatigue_test.json';
% configFilePath = '../Data_json/LinConfig/IOC_IITFatigue_Subj1_demo.json';
configFilePath = '../Data_json/LinConfig/IOC_IITFatigue_SubjAll_full_3CF.json';
% configFilePath = '../Data_json/LinConfig/IOC_Healthy1.json';
% configFilePath = '../Data_json/LinConfig/IOC_Jumping2D.json';

saveSuffix = '20200413_FatigueFull_3CF';
% savePath = sprintf('D:/results/fatigue_ioc01_weightsIndividual/%s/', saveSuffix);
savePath = sprintf('D:/aslab_github/ioc/Data/IOC/%s/', saveSuffix);

% Wanxin's Configurations
% configFilePath = '../Data_json/JinConfig/Squat_IIT/IOC_IITFatigue_Test_Sub1.json';
% configFilePath = '../Data_json/JinConfig/Jump/IOC_Github_Jumping2D_Sub2.json';
% configFilePath = '../Data_json/LinConfig/IOC_Healthy1.json';

% configFilePath='../Data_json/JinConfig/HipFlexion/IOC_HipFlexion_Sub1.json';
% configFilePath='../Data_json/JinConfig/KneeHipFlexion/IOC_KneeHipFlexion_Sub1.json';
% configFilePath='../Data_json/JinConfig/SitToStand/IOC_SitToStand_Sub1.json';
% configFilePath='../Data_json/JinConfig/Squat/IOC_Squat_Sub1.json';

%% Set up internal parameters
% Add paths to directories with model definition and util functions
setPaths();

% Load json file with list of all trials on which IOC will be run
configFile = jsondecode(fileread(configFilePath));
n = length(configFile.Files);

for i=1:n
    runParam = [];
    configFileI = configFile.Files(i);

    % if the source matfile is not found in the json path, search these
    % following locations as well, such as for Sharcnet deployment
    potentialBasePaths = {'/project/6001934/data/', ...
        'D:/aslab/data_IK', ...
        'D:/aslab_svn/data_IK', ...
        configFileI.basepath, ...
        'H:/data'};
    
    % load the specific trialinfo
    fprintf("Processing %s file \n", configFileI.runName);
    trialInfo = loadTrialInfo(configFileI, configFile, potentialBasePaths, configFilePath);

    % does the target folder already exist? 
    subsavePath = fullfile(savePath, trialInfo.runName);
    [status, alreadyExist] = checkMkdir(subsavePath);
    
    if ~alreadyExist || overwriteFiles
        IOCRun(trialInfo, subsavePath);
%         IOCIncomplete(trialInfo,savePath)
    end
end

toc