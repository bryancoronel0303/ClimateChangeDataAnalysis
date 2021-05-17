% THIS IS THE START OF A NEW FUNCTION
% exploring: function T = exploring(T)
%
% This function outputs unique values of your table to see what the
% variables contained are
% output:
%   T = a modified table with dropped rows of data that is not sufficient
% input: 
%   T = the original table that was imported initially
function T = exploring(T)
% exploring features and their general statistics
data_summary = summary(T);
% how many observations do we have originally?
observations = height(T)
% From data set description, temperature values of -99 signify no data was availble for that date
% I will drop these rows via logical indexing so that they don't interfere with plots and MATLAB commands
% condition I'm looking for
toDelete = T.AvgTemperature ==-99 | T.Year == 200 | T.Year == 201;
% the deletion
T(toDelete,:) = [];
% checking to see how many observations I have now
observations_after_drop = height(T)
% out of curiosity, how many observations did we lose? presented as a percentage
lostrows = abs(observations_after_drop-observations)/observations*100
% here I'm exploring the unique regions in the data set
regions = unique(T(:,1))
% here I'm exploring the years for which the data is recorded
years = unique(T(:,7))
% here I'm trying to see which cities are in the set
cities = unique(T(:,4));
% here I'm trying to see which countries are in the set
countries = unique(T(:,2))
end