name2use = 'GB_BUFFS4_LScene_L_MC';

tmp3ddata = findall(gcf, 'Type', 'Patch');

caseID = name2use;
caseDIR = 'C:\Users\Admin\Desktop\BUFFs_LEADDBS';
cd(caseDIR)
save(caseID , "tmp3ddata");

disp('saved')


%%

% These change if you don't have bilateral VTAs!!

leftVTA.vertices = illinskyAll(5).Vertices;
leftVTA.faces = illinskyAll(5).Faces;

figure;
drawMesh(leftVTA.vertices, leftVTA.faces)

rightVTA.vertices = illinskyAll(90).Vertices;
rightVTA.faces = illinskyAll(90).Faces;
hold on
drawMesh(rightVTA.vertices, rightVTA.faces)


DBSSleep_06.left.VTA = leftVTA;
DBSSleep_06.right.VTA = rightVTA;


%%

dbsscene = {'STN_motor_left', 'STN_motor_right', 'STN_left',...
    'STN_right', 'STN_limbic_left','STN_limbic_right',...
    'STN_associative_left', 'STN_associative_right'};

stnMESHS = struct;
for i = 1:length(tmp3ddata)
    tmpobj = tmp3ddata(i);
    tmptag = tmpobj.Tag;
    dbsflag = ismember(tmptag, dbsscene);
    if dbsflag
        stnMESHS.(tmptag).vertices = tmpobj.Vertices;
        stnMESHS.(tmptag).faces = tmpobj.Faces;
    else
        continue
    end
end


dbsMESHS = struct;
for i = 1:length(tmp3ddata)
    tmpobj = tmp3ddata(i);
    tmptag = tmpobj.Tag;
    dbsflag = contains(tmptag, {'Contact','Insulation'});
    if dbsflag
        tmptag2 = replace(tmptag,'-','');
        dbsMESHS.(tmptag2).vertices = tmpobj.Vertices;
        dbsMESHS.(tmptag2).faces = tmpobj.Faces;
    else
        continue
    end
end