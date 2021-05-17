clear; close all; clc; format compact;
% NOTE: the file is separated by sections but can be run as a whole. A lot
% of output will be spit out in the command window. All of it is relevant. 
% NOTE: please resize graphs as you see fit, I cannot account for how plots
% look on different computers.
% NOTE: I hope you enjoy looking at my work. I enjoyed analyzing
% this data so much that I'm publishing this project to my github!
% importing csv file as a table, so that it is easier to splice and index
global T month country_array;
T = readtable('city_temperature.csv');
%% exploring
clearvars -except T; close all; clc; format compact;
% Check out the function file to see my comments and code!
T = exploring(T);
%% regression and root-finding
clearvars -except T & country_array & month; close all; clc; format compact;
% I initialized some values for the parameters of my functions for you, but
% feel free to changed them to see that I didn't "hard-code" anything
month = 9; forecast_year = 2019;
country_array = ["Saudi Arabia", "Qatar", "Kuwait", "United Arab Emirates", "Bahrain", "Egypt"];
stats = linreg_rootfinding(T, country_array, month,forecast_year)
%% splines, differentiation and optimization
month = 7;
country_array = ["Saudi Arabia", "Qatar", "Kuwait", "United Arab Emirates","Bahrain", "Egypt"];
rate = spline_diff_opt(T,country_array,month)
