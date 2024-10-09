function [volumeSTN , volumeCON1, volumeOVERlap , ...
    percentOverlapOFSTN_BYcontact] = contactOVERLapSTN(STNmesh , Contactmesh)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%%%%%%%%%%%%%%%%% EXAMPLE
% facesA = outputmesh.STN_left.faces; 
% facesA = fliplr(facesA);   
% verticesA = outputmesh.STN_left.vertices;
% facesB = outputmesh.sub_UNMC11_Contact1_Side2.faces;
% verticesB = outputmesh.sub_UNMC11_Contact1_Side2.vertices;

facesA = STNmesh.faces;
facesA = fliplr(facesA);
verticesA = STNmesh.vertices;
facesB = Contactmesh.faces;
verticesB = Contactmesh.vertices;

% Define grid resolution
resolution = 100; % Adjust as needed

% Calculate bounding box
allVertices = [verticesA; verticesB];
minCoords = min(allVertices, [], 1);
maxCoords = max(allVertices, [], 1);

% Create grid vectors
xGrid = linspace(minCoords(1), maxCoords(1), resolution);
yGrid = linspace(minCoords(2), maxCoords(2), resolution);
zGrid = linspace(minCoords(3), maxCoords(3), resolution);

% Generate 3D grid using ndgrid
[X, Y, Z] = ndgrid(xGrid, yGrid, zGrid);

% Flatten grid points
gridPoints = [X(:), Y(:), Z(:)];

% Voxelize Mesh A
in_STN = inpolyhedron(facesA, verticesA, gridPoints);

% Voxelize Mesh B
in_CON1 = inpolyhedron(facesB, verticesB, gridPoints);

% Reshape results back to 3D grids
vol_STN = reshape(in_STN, size(X));
vol_CON1 = reshape(in_CON1, size(X));

% Compute the overlapping volume
overlapVol = vol_STN & vol_CON1;

% Obtain indices of overlapping voxels
[ix, iy, iz] = ind2sub(size(overlapVol), find(overlapVol));

% Map indices to spatial coordinates
xOverlap = xGrid(ix);
yOverlap = yGrid(iy);
zOverlap = zGrid(iz);

% Visualize Mesh A
figure;
patch('Faces', facesA, 'Vertices', verticesA, 'FaceColor', 'red', 'FaceAlpha', 0.5, 'EdgeColor', 'none');
hold on;

% Visualize Mesh B
patch('Faces', facesB, 'Vertices', verticesB, 'FaceColor', 'blue', 'FaceAlpha', 0.5, 'EdgeColor', 'none');

% Visualize Overlapping Voxels
scatter3(xOverlap, yOverlap, zOverlap, 10, 'green', 'filled');

xlabel('X');
ylabel('Y');
zlabel('Z');
title('Visualization of Meshes and Overlapping Region');
legend('Mesh A', 'Mesh B', 'Overlap');
axis equal;
grid on;
view(3); % Set a 3D view

% Calculate voxel volume
voxelVolume = (xGrid(2) - xGrid(1)) * (yGrid(2) - yGrid(1)) * (zGrid(2) - zGrid(1));
volumeSTN = sum(vol_STN(:)) * voxelVolume;
volumeOVERlap = sum(overlapVol(:)) * voxelVolume;
volumeCON1 = sum(vol_CON1(:)) * voxelVolume;
% Percent overlap relative to Mesh A
percentOverlapOFSTN_BYcontact = (volumeOVERlap / volumeCON1) * 100;
title(['STN overlap % = ',num2str(percentOverlapOFSTN_BYcontact,3)])


end