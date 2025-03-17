illinskyAll = findall(gcf, 'Type', 'Patch')

caseID = 'TC202105 ANT DBS';
caseDIR = 'C:\Users\Emi_Buchanan\Desktop\VOlBrain\TC202105 ANT DBS';
caseNAME_I = [caseID , '_Illinsky.mat'];
cd(caseDIR)
save(caseNAME_I , "illinskyAll");


%%
morelAll = findall(gcf, 'Type', 'Patch')

caseNAME_M = [caseID , '_Morel.mat'];
cd(caseDIR)
save(caseNAME_M , "morelAll");


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

dbsscene = {'STN_motor_left', 'STN_motor_right', 'STN_left', 'STN_right', 'STN_limbic_left','STN_limbic_right', 'STN_associative_left', 'STN_associative_right'};

   outputmesh = struct;
for i = 1:length(allobj)
    tmpobj = allobj(i);
    tmptag = tmpobj.Tag;
   dbsflag = ismember(tmptag, dbsscene);
   if dbsflag
       outputmesh.(tmptag).vertices = tmpobj.Vertices;
       outputmesh.(tmptag).faces = tmpobj.Faces;
   else 
       continue 
   end
end