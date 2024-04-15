% Define vehicle and track parameters
sim_time = 130;
straight_length = 900; % Length of straight sections in meters
curve_radius = 200; % Radius of curved sections in meters
track_width = 15; % Width of the track in meters
num_waypoints = 100; % Number of waypoints

% Calculate delta_s for equal spacing of waypoints and delta_theta for curves
total_length = 2 * straight_length + 2 * pi * curve_radius;
delta_s = total_length / (num_waypoints - 1);
delta_theta = delta_s / curve_radius;  

% Initialize arrays for coordinates
x = zeros(1, num_waypoints);
y = zeros(1, num_waypoints);
theta = zeros(1, num_waypoints);

% Generate waypoints for the track
for i = 1:num_waypoints
    % First straight section
    if (i-1) * delta_s <= straight_length 
        x(i) = (i - 1) * delta_s;
        y(i) = 0;

    % First curved section
    elseif (i-1) * delta_s <= straight_length + pi * curve_radius 
        segment_s = (i - 1) * delta_s - straight_length;
        [x(i), y(i)] = rotate_point(straight_length, 0, straight_length, curve_radius, segment_s / curve_radius);
        
    % Second straight section
    elseif (i-1) * delta_s <= 2 * straight_length + pi * curve_radius 
        segment_s = (i - 1) * delta_s - (straight_length + pi * curve_radius);
        x(i) = straight_length - segment_s;
        y(i) = 2 * curve_radius;
        
    % Second curved section
    else 
        segment_s = (i - 1) * delta_s - (2 * straight_length + pi * curve_radius);
        [x(i), y(i)] = rotate_point(0, 0, 0, curve_radius, pi + segment_s / curve_radius);
    end
end

% Define track parameters for race statistics
path = struct('radius', curve_radius, 'width', track_width, 'l_st', straight_length);

% Simulate the vehicle path
out = sim("Project_4_Simulink_Update.slx", "StopTime", num2str(sim_time));

% Plot the track and vehicle path
plot(x, y, 'b', 'LineWidth', track_width);
hold on;
plot(out.x.Data, out.y.Data, 'r--', 'LineWidth', 2);
xlim([-300, 1200])
ylim([-400, 900])

% Plot and animate the vehicle on the track
rect_length = track_width * 5; % Increase the patch length
rect_width = track_width * 2.5; % Increase the patch width
vehicle_patch = patch([0, rect_length, rect_length, 0], [-rect_width/2, -rect_width/2, rect_width/2, rect_width/2], 'k', 'FaceAlpha', 0.8);
for i = 2:length(out.x.Data)
    dx = out.x.Data(i) - out.x.Data(i-1);
    dy = out.y.Data(i) - out.y.Data(i-1);
    set(vehicle_patch, 'XData', get(vehicle_patch, 'XData') + dx, 'YData', get(vehicle_patch, 'YData') + dy);
    drawnow; % Update the plot
end

% Finalize the plot
hold off;
axis equal;
title('Race Track with Vehicle Path');
xlabel('X (m)');
ylabel('Y (m)');
legend('Track', 'Vehicle Path');

% Function to rotate points for curved sections
function [x_rotated, y_rotated] = rotate_point(x_origin, y_origin, x_center, y_center, angle)
    R = [cos(angle), -sin(angle); sin(angle), cos(angle)];
    translated = R * ([x_origin; y_origin] - [x_center; y_center]);
    x_rotated = translated(1) + x_center;
    y_rotated = translated(2) + y_center;
end
