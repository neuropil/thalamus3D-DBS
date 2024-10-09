%% FOR LEAD DBS SCENE
% Determine which contact numbers are LEFT and RIGHT

% 1. Loop 1 through subject 11
% 2. Loop 2 through atlas scene 2
% 3. Loop 3 through hemisphere 2
% 2. Loop 4 through X structures ? 
% 3. Loop 5 through 4 contacts 4
% 4. Output percentOverlap and IMAGE

[volumeSTN , volumeCON1, volumeOVERlap , ...
    percentOverlapOFSTN_BYcontact] = contactOVERLapSTN(brainMESH , contactMESH)



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

[volumeSTN , volumeCON1, volumeOVERlap , ...
    percentOverlapOFSTN_BYcontact] = contactOVERLapSTN(brainMESH , contactMESH)
