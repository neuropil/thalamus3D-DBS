 %% FOR LEAD DBS SCENE
% Determine which contact numbers are LEFT and RIGHT

% 1. Loop 1 through subject 11 - DONE
% 2. Loop 2 through atlas scene 2 - DONE
% 3. Loop 3 through hemisphere 2
% 2. Loop 4 through X structures ? 
% 3. Loop 5 through 4 contacts 4
% 4. Output percentOverlap and IMAGE

mainDIR = 'C:\Users\Emi_Buchanan\Desktop\VOlBrain';

cd(mainDIR)

folderDIR = dir();
folderTAB = struct2table(folderDIR);

folderDIR3 = folderTAB.name(~matches(folderTAB.name,{'.','..'}) & folderTAB.isdir);

for fii = 1:length(folderDIR3)

    tmpFold = folderDIR3{fii};
    tmpSubF = [mainDIR , filesep , tmpFold];
    cd(tmpSubF)

    outputmesh = struct;

    dbsSCEnes = {'Illinsky','Morel'};
    for dbsS = 1:2

        tmpScene = dbsSCEnes{dbsS};
        % locate altas struct and load
        matList = dir('*.mat');
        matList2 = {matList.name};

        atlasStr = matList2{contains(matList2,tmpScene)};
        load(atlasStr)
        contACTnames = cell(1,4);
        for ii = 1:4
            tmpFold2 = replace(tmpFold,{' ','_'},{'',''});
            contACTnames{ii} = ['sub-',tmpFold2,'_Contact',num2str(ii)];
        end

        switch dbsS
            case 1
                tmpDBSscene = {'VAp','VAn','A',...
                    'VLdVLv', 'VPlVPm','VPi'};

                allDBS_blobs = illinskyAll;
                atlasOUT = 'ILL';
            case 2

                tmpDBSscene = {'VPLp','VPLa','VApc',...
                    'VAmc','AV','AM','AD'};

                allDBS_blobs = morelAll;
                atlasOUT = 'MOR';
        end

        sideSSS = {'L','R'}; % left is side 2

        for ssi = 1:2

            switch ssi
                case 1
                    addHemi = '_left';
                    addSide = '_Side2';
                    sideOUT = 'L';
                case 2
                    addHemi = '_right';
                    addSide = '_Side1';
                    sideOUT = 'R';
            end

            % FIX blobs
            tmpDBSscene2 = cellfun(@(x) [x , addHemi], tmpDBSscene, 'UniformOutput',false);
            contACTnames2 = cellfun(@(x) [x , addSide], contACTnames, 'UniformOutput',false);
            allBLOBS = [tmpDBSscene2 , contACTnames2];

  
            for i = 1:length(allDBS_blobs)
                tmpobj = allDBS_blobs(i);
                tmptag = tmpobj.Tag;
                dbsflag = ismember(tmptag, allBLOBS);
                if dbsflag

                    if contains(tmptag,'Contact')
                        tmptag = extractAfter(tmptag,'-');
                    end

                    outputmesh.(atlasOUT).(sideOUT).(tmptag).vertices = tmpobj.Vertices;
                    outputmesh.(atlasOUT).(sideOUT).(tmptag).faces = tmpobj.Faces;
                else
                    continue
                end
            end

        end
    end

    % saveFILE
    saveNAME = [tmpFold '_AtlasMESH.mat'];
    save(saveNAME,'outputmesh');
    disp([saveNAME , ' complete'])

end


%%

mainDIR = 'C:\Users\Emi_Buchanan\Desktop\VOlBrain';
cd(mainDIR)
folderDIR = dir();
folderTAB = struct2table(folderDIR);
folderDIR3 = folderTAB.name(~matches(folderTAB.name,{'.','..'}) & folderTAB.isdir);

subjectID = {};
atlasID = {};
hemiID = {};
brainID = {};
contactID = {};
perOVERlap = [];
count = 1;
for fii = 1:length(folderDIR3)

    tmpFold = folderDIR3{fii};
    tmpSubF = [mainDIR , filesep , tmpFold];
    cd(tmpSubF)

    % Load all meshes
    matList = dir('*.mat');
    matList2 = {matList.name};

    atlasStr = matList2{contains(matList2,'AtlasMESH')};
    load(atlasStr,'outputmesh')

    altasLIST = fieldnames(outputmesh);

    disp(tmpFold)

    for aai = 1:length(altasLIST)

        tmpAtlas = altasLIST{aai};

        hemiLIST = fieldnames(outputmesh.(tmpAtlas));

        disp(tmpAtlas)

        for hii = 1:length(hemiLIST)

            tmpHEMI = hemiLIST{hii};
            tmpBLOBS = fieldnames(outputmesh.(tmpAtlas).(tmpHEMI));

            disp(tmpHEMI)

            brainAreaListRAW = tmpBLOBS(~contains(tmpBLOBS,'Contact'));
            brainAreaListClean = extractBefore(brainAreaListRAW,'_');
            contactListRAW = tmpBLOBS(contains(tmpBLOBS,'Contact'));
            contactListClean = extractBetween(contactListRAW,'_','_');

            for baI = 1:length(brainAreaListRAW)

                for conI = 1:length(contactListRAW)
                    brainMESH = outputmesh.(tmpAtlas).(tmpHEMI).(brainAreaListRAW{baI});
                    contactMESH = outputmesh.(tmpAtlas).(tmpHEMI).(contactListRAW{conI});
                    [~ , ~, ~ , ...
                        percentOverlapBYcontact] = contactOVERLapSTN(brainMESH , contactMESH);


                    disp(brainAreaListRAW{baI})
                    disp(contactListRAW{conI})

                    subjectID{count} = tmpFold;
                    atlasID{count} = tmpAtlas;
                    hemiID{count} = tmpHEMI;
                    brainID{count} = brainAreaListClean{baI};
                    contactID{count} = contactListClean{conI};
                    perOVERlap(count) = percentOverlapBYcontact;

                    count = count + 1;


                end
            end
            close all
        end
    end
end

leadDBSVolTab = table(transpose(subjectID),transpose(atlasID),...
    transpose(hemiID),transpose(brainID),transpose(contactID),...
    transpose(perOVERlap),'VariableNames',{'Subject','Atlas',...
    'HemiS','BrainReg','ContactN','PercetOver'});


save('LeadDBS_ThalamsVol.mat',"leadDBSVolTab")


%% For VOL BRAIN

% 1. Loop 1 through subject 11
% 2. Loop 2 through hemisphere 2
% 3. Loop 3 through brain structure 3
% 4. For each brain structure 
%    i. [faces, vertices] = isosurface(brain3D, 0.5);
%    ii. brainMesh.faces = faces; brainMesh.vertices = vertices;
% 5. Loop 4 through the 4 contacts
% 6. For each contact
%    i. region props 3D on all 4 contacts
%    ii. create 3D mask for each individual contact
%    iii. [faces, vertices] = isosurface(contact3D, 0.5);
%    iv. contactMesh.faces = faces; contactMesh.vertices = vertices;
clear; clc
mainDIR = 'C:\Users\Emi_Buchanan\Desktop\VOlBrain';
cd(mainDIR)
folderDIR = dir();
folderTAB = struct2table(folderDIR);
folderDIR3 = folderTAB.name(~matches(folderTAB.name,{'.','..'}) & folderTAB.isdir);

folds2skip = {};

folderDIR3 = folderDIR3(~matches(folderDIR3,folds2skip));

for fii = 1:length(folderDIR3) % N = 15

    % Obtain temporary subject folder
    tmpFold = folderDIR3{fii};
    saveLOC = [mainDIR , filesep , tmpFold];
    % Combine with MainDir and Voloutput
    tmpSubF = [mainDIR , filesep , tmpFold , filesep , 'voloutput\volNIFTI'];
    cd(tmpSubF)

    % Find and Load NII file
    gzList = dir('*.gz');
    gztList2 = {gzList.name};

    volbrainNII = gztList2{contains(gztList2,'native_nuclei')};
    brain3D = niftiread(volbrainNII);

    % Thalamic regions: AVN, VAN, VLAN, MTT
    % Label 1, 2, 3, 4, 5, 6, 23, 24
    labelNUMS = [1 2 3 4 5 6 23 24]; 
    labelIDS = {'AVN','AVN','VAN','VAN','VLAN','VLAN','MTT','MTT'};
    labelHEMIS = {'L','R','L','R','L','R','L','R'};

    % Isolate index of interest
    for lli = 1:length(labelNUMS)

        indexMATrix = brain3D;
        indexMATrix(brain3D ~= labelNUMS(lli)) = 0;
        [faces, vertices] = isosurface(indexMATrix, 0.5);
        brainMesh.faces = faces;
        brainMesh.vertices = vertices;

        sideOUT = labelHEMIS{lli};
        tmptag = labelIDS{lli};

        outputmesh.VolMorel.(sideOUT).(tmptag).vertices = brainMesh.vertices;
        outputmesh.VolMorel.(sideOUT).(tmptag).faces = brainMesh.faces;

    end

    % saveFILE
    cd(saveLOC)
    saveNAME = [tmpFold '_VolBrainMESH.mat'];
    save(saveNAME,'outputmesh');
    disp([saveNAME , ' complete'])


end % LOOP THROUGH EACH SUBJECT FOLDER


%% GET VOLbrain contact blobs

clear;clc

folds2skip = {};

mainDIR = 'C:\Users\Emi_Buchanan\Desktop\VOlBrain';
cd(mainDIR)
folderDIR = dir();
folderTAB = struct2table(folderDIR);
folderDIR3 = folderTAB.name(~matches(folderTAB.name,{'.','..'}) & folderTAB.isdir);

folderDIR3b = folderDIR3(~matches(folderDIR3,folds2skip));

for fii = 1:length(folderDIR3b)

    tmpFold = folderDIR3b{fii};
    saveLOC = [mainDIR , filesep , tmpFold];
    tmpSubF = [mainDIR , filesep , tmpFold];
    cd(tmpSubF)

    hemiIDSs = {'L','R'};

    % 2, 3, 6, 1
    eleLABels = [2 , 3 , 6 , 1];
    contactIDSs = [ 0, 1, 2, 3];

    disp([num2str(fii), ' out of ', num2str(length(folderDIR3b))])

    for hhii = 1:length(hemiIDSs)

        if matches(hemiIDSs{hhii},'L')
            tmpELEmatrix = niftiread('testELEmask_L_contacts.nii');
        else
            tmpELEmatrix = niftiread('testELEmask_R_contacts.nii');
        end

        disp(tmpFold)
        unique(tmpELEmatrix)

        if numel(unique(tmpELEmatrix)) == 2
            keyboard
        end

        % tmpELEBL = logical(tmpELEmatrix);
        % labeledMat = bwlabeln(tmpELEBL);
        % blobsTMP = regionprops3(labeledMat,'Centroid','Volume');

        % numBLOBs = max(labeledMat(:));
        % blobVertices = cell(numBLOBs,1);
        % blobFaces = cell(numBLOBs,1);
        % linkedProps = struct('Centroid',[],'Volume',[],'Vertices',[],'Faces',[]);

        for i = 1:4
            blobMask = (tmpELEmatrix == eleLABels(i));
            [faces,vertices] = isosurface(blobMask,0.5);
            blobVertices = vertices;
            blobFaces = faces;

            % linkedProps(i).Centroid = blobsTMP.Centroid(i,:);
            % linkedProps(i).Volume = blobsTMP.Volume(i,:);
            % linkedProps(i).Faces = blobFaces{i};
            % linkedProps(i).Vertices = blobVertices{i};
            conID = ['C',num2str(contactIDSs(i))];
            elecmesh.(hemiIDSs{hhii}).(conID).vertices = blobVertices;
            elecmesh.(hemiIDSs{hhii}).(conID).faces = blobFaces;
        end

        % blobPROPS = struct2table(linkedProps);

        % [~ , sortIdx] = sort(blobPROPS.Centroid(:,3),'descend');
        % orderBlobs = blobPROPS(sortIdx,:);
        % orderLabels = sortIdx;

        % contactIDSs = [3 2 1 0];
        % for ccii = 1:4
        %     conID = ['C',num2str(contactIDSs(ccii))];
        % 
        %     elecmesh.(hemiIDSs{hhii}).(conID).vertices = orderBlobs.Vertices{ccii};
        %     elecmesh.(hemiIDSs{hhii}).(conID).faces = orderBlobs.Faces{ccii};
        % 
        % end
    end

    % saveFILE
    cd(saveLOC)
    saveNAME = [tmpFold '_VolELEC_MESH.mat'];
    save(saveNAME,'elecmesh');
    disp([saveNAME , ' complete'])

end


%%

clear;clc
folds2skip = {};

mainDIR = 'C:\Users\Emi_Buchanan\Desktop\VOlBrain';
cd(mainDIR)
folderDIR = dir();
folderTAB = struct2table(folderDIR);
folderDIR3 = folderTAB.name(~matches(folderTAB.name,{'.','..'}) & folderTAB.isdir);

folderDIR3b = folderDIR3(~matches(folderDIR3,folds2skip));

subjectID = {};
hemiID = {};
brainID = {};
contactID = {};
perOVERlap = [];
count = 1;

for fii = 1:length(folderDIR3b)

    tmpFold = folderDIR3b{fii};
    tmpSubF = [mainDIR , filesep , tmpFold];
    cd(tmpSubF)

    % Load all meshes
    matList = dir('*.mat');
    matList2 = {matList.name};

    volATLAS = matList2{contains(matList2,'VolBrainMESH')};
    load(volATLAS,'outputmesh')
    eleMESH = matList2{contains(matList2,'VolELEC_MESH')};
    load(eleMESH,'elecmesh')

    disp(tmpFold)

    hemiLIST = fieldnames(outputmesh.VolMorel);

    for hii = 1:length(hemiLIST)

        tmpHEMI = hemiLIST{hii};
        tmpBLOBS = fieldnames(outputmesh.VolMorel.(tmpHEMI));
        tmpCONS = fieldnames(elecmesh.(tmpHEMI));

        disp(tmpHEMI)

        for baI = 1:length(tmpBLOBS)

            for conI = 1:length(tmpCONS)
                brainMESH = outputmesh.VolMorel.(tmpHEMI).(tmpBLOBS{baI});
                contactMESH = elecmesh.(tmpHEMI).(tmpCONS{conI});
                [~ , ~, ~ , ...
                    percentOverlapBYcontact] = contactOVERLapSTN(brainMESH , contactMESH);

                disp(tmpBLOBS{baI})
                disp(tmpCONS{conI})

                subjectID{count} = tmpFold;
                hemiID{count} = tmpHEMI;
                brainID{count} = tmpBLOBS{baI};
                contactID{count} = tmpCONS{conI};
                perOVERlap(count) = percentOverlapBYcontact;

                count = count + 1;

            end
        end
        % close all
    end
end


cd('C:\Users\Emi_Buchanan\Desktop\VOlBrain')
VolBRAINVolTab = table(transpose(subjectID),...
    transpose(hemiID),transpose(brainID),transpose(contactID),...
    transpose(perOVERlap),'VariableNames',{'Subject',...
    'HemiS','BrainReg','ContactN','PercetOver'});

save('VolBrainMorel_ThalamsVol.mat',"VolBRAINVolTab")

%%




% 
% [volumeSTN , volumeCON1, volumeOVERlap , ...
%     percentOverlapOFSTN_BYcontact] = contactOVERLapSTN(brainMESH , contactMESH)
