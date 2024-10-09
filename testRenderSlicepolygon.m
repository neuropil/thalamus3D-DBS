% Define the size of the 3D matrix
dataSize = [100, 100, 100];
brainData = zeros(dataSize);

% Define centers and radii for 5 blobs
centers = [30, 30, 30;
    70, 30, 30;
    30, 70, 30;
    30, 30, 70;
    70, 70, 70];

radii = [15, 10, 12, 8, 13];

% Assign unique labels to each blob
for i = 1:5
    % Generate a grid of coordinates
    [X, Y, Z] = ndgrid(1:dataSize(1), 1:dataSize(2), 1:dataSize(3));
    % Equation of a sphere centered at centers(i,:) with radius radii(i)
    sphereMask = (X - centers(i,1)).^2 + (Y - centers(i,2)).^2 + (Z - centers(i,3)).^2 <= radii(i)^2;
    % Assign integer label i to the sphere region
    brainData(sphereMask) = i;
end

sliceNumber = 25;
slice2D = brainData(:,:,sliceNumber);

% Plot the segmented slice
plotSegmentedSlice(slice2D);