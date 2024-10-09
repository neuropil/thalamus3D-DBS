function plotSegmentedSlice(slice2D)
    % Function to plot segmented regions in a 2D slice as filled polygons

    % Get the unique labels (excluding background if labeled as 0)
    labels = unique(slice2D);
    labels(labels == 0) = []; % Remove background label if necessary

    figure; hold on;
    % Generate a color map with as many colors as there are labels
    cmap = lines(length(labels));

    for idx = 1:length(labels)
        label = labels(idx);
        % Create a binary mask for the current label
        bw = (slice2D == label);

        % Find boundaries of the labeled regions
        boundaries = bwboundaries(bw);

        % Plot each boundary as a filled polygon
        for k = 1:length(boundaries)
            boundary = boundaries{k};
            % Note: boundary(:,2) is x-coordinate, boundary(:,1) is y-coordinate
            fill(boundary(:,2), boundary(:,1), cmap(idx,:), 'EdgeColor', 'none');
        end
    end

    axis equal;
    axis ij; % Correct the axis to match image coordinate system
    xlabel('X-axis');
    ylabel('Y-axis');
    title('Segmented Brain Regions as Filled Polygons');
    hold off;
end
