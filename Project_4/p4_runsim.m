DriveData = HighwayDriveData; 
Time = HighwayTime;
HighwayT = 765;

out = sim("Project_4_Simulink_Update.slx", "StopTime", "3600");
car_X = out.X.Data;
car_Y = out.Y.Data;
car_time = out.X.Time;
car_vel = out.veh_speed.Data;

% path_x = path.xpath;
% path_y = path.ypath;

race = raceStat(car_X, car_Y, car_time, path, out)
lefttrack = race.leftTrack