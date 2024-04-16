%Initiation

% Define vehicle parameters
Car_Velocity = 8;
sim_time = 15;

%Define track parameters
straight_length = 900; % Length of straight sections in meters
curve_radius = 200; % Radius of curved sections in meters
track_width = 15; % Width of the track in meters
num_waypoints = 100; % Number of waypoints

% Calculate delta_s for equal spacing of waypoints
total_length = 2 * straight_length + 2 * pi * curve_radius;
delta_s = total_length / (num_waypoints - 1);

% Calculate delta_theta for curved sections
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
        theta(i) = 0; % Straight section, no change in theta

    % First curved section
    elseif (i-1) * delta_s <= straight_length + pi * curve_radius 
        segment_s = (i - 1) * delta_s - straight_length;
        theta(i) = segment_s / curve_radius;
        [x(i), y(i)] = rotate_point(...
            straight_length, 0, straight_length, curve_radius, theta(i));
        
    % Second straight section
    elseif (i-1) * delta_s <= 2 * straight_length + pi * curve_radius 
        segment_s = (i - 1) * delta_s - straight_length - pi * curve_radius;
        x(i) = straight_length - segment_s;
        y(i) = 2 * curve_radius;
        theta(i) = pi; % Straight section, no change in theta
        
    % Second curved section
    else 
        segment_s = (i - 1) * delta_s - 2 * straight_length - pi * curve_radius;
        theta(i) = pi + segment_s / curve_radius;
        [x(i), y(i)] = rotate_point(0, 0, 0, curve_radius, theta(i));
    end
end

% Call raceStat.m script
path.radius = 200; % Radius of Curves
path.width = 15; % Width of the Track
path.l_st = 900; % Length of Straightaways



Wp = [transpose(x), transpose(y)];
delta_f = 0;

open_system('Project_4_Simulink_Update');
set_param('Project_4_Simulink_Update', 'StopTime', num2str(sim_time));

DriveData = HighwayDriveData; 
Time = HighwayTime;
HighwayT = 765;

close_system('Project_4_Simulink_Update', 0);

%% Run Simulation %%
out = sim("Project_4_Simulink_Update.slx", "StopTime", "500");

%% Extract Data from Simulation Output %%
car_X = out.X.Data;
car_Y = out.Y.Data;
car_time = out.X.Time;
car_vel = out.veh_speed.Data;
SOC = out.SOC.Data; 
brake_viol = out.brake.Data; 

%% Analysis with raceStat %%
path.width = track_width; % Use track_width from your initialization code
path.l_st = straight_length; % Use straight_length from your initialization code
path.radius = curve_radius; % Use curve_radius from your initialization code

raceStats = raceStat(car_X, car_Y, car_time, path, out);

%% Display Results %%
disp(raceStats);


%%% Plotting Code %%%
figure;
plot(x, y, 'b', 'LineWidth', track_width); % Plot track
hold on;
xlim([-300, 1200]);
ylim([-400, 900]);

% Plot the vehicle's path
plot(car_X, car_Y, 'r--', 'LineWidth', 2);

% Define the rectangular patch that represents the vehicle
rect_length = track_width * 5;  % Increase the patch length
rect_width = track_width * 2.5; % Increase the patch width
vehicle_patch = patch([0, rect_length, rect_length, 0], [-rect_width/2, -rect_width/2, rect_width/2, rect_width/2], 'k');
rotate(vehicle_patch, [0 0 1], rad2deg(theta(1)), [x(1) y(1) 0]);
alpha(vehicle_patch, 0.8); % Set transparency

axis equal;
title('Race Track with Vehicle Path');
xlabel('X (m)');
ylabel('Y (m)');
legend('Track', 'Vehicle Path');

% Animation loop for the vehicle patch following the waypoints
for i = 2:length(car_X)
    % Calculate new theta for orientation
    theta(i) = atan2(car_Y(i) - car_Y(i-1), car_X(i) - car_X(i-1));
    
    % Update vehicle position and orientation
    set(vehicle_patch, 'XData', vehicle_patch.XData + (car_X(i) - car_X(i-1)), ...
                       'YData', vehicle_patch.YData + (car_Y(i) - car_Y(i-1)));
    rotate(vehicle_patch, [0 0 1], rad2deg(theta(i) - theta(i-1)), [car_X(i) car_Y(i) 0]);
    
    drawnow; % Update the plot with new position and orientation
end

hold off; % Release the plot hold

% Function to rotate points around a center
function [x_rotated, y_rotated] = rotate_point(x, y, x_center, y_center, theta)
    R = [cos(theta), -sin(theta);
         sin(theta), cos(theta)];
    % Translate the point to be rotated to the origin
    x_translated = x - x_center;
    y_translated = y - y_center;
    % Perform the rotation using rotation matrix
    rotated_coords = R * [x_translated; y_translated];
    % Translate the rotated point back to its original position
    x_rotated = rotated_coords(1,:) + x_center;
    y_rotated = rotated_coords(2,:) + y_center;
end