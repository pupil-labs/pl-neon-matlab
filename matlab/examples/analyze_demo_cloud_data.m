% Import events and fixations from the csv files as tables
events = readtable("2024-09-17_11-06-49-171c4f52/events.csv");
fixations = readtable("2024-09-17_11-06-49-171c4f52/fixations.csv");

% Take only those events with Picture in the name as this is what we used
% in demo_pupil_labs to target our events.
events = events(contains(events.name, "Picture"), :);
start_events = events(contains(events.name, "start"), :);
end_events = events(contains(events.name, "end"), :);

% New array matching events and fixations
for nImage = 1:height(start_events)
    imIndex(1,nImage) = nImage;
    fixperIm(1, nImage) = sum(fixations.startTimestamp_ns_ >= start_events.timestamp_ns_(nImage) &...
        fixations.endTimestamp_ns_ <= end_events.timestamp_ns_(nImage));
end

% Plot the data
bar(imIndex,fixperIm);
axis square; grid minor;
ylim([0 max(fixperIm)+1]);
xlabel('Image'); ylabel(['Number of fixations', newline]);
title(['Fixations per image - Neon', newline]);