% THIS IS THE START OF A NEW FUNCTION
% spline_diff_opt: function rate = spline_diff_opt(T,country_array,month)
% 
% This function employs the use of splines to differentiate and optimize
% them to explore rates of temperature change per year
% output:
%   rate = a table of the rates of temperature change per country
% input:
%   T = table of data that must be imported first
%   country_array = is a string array that contains country names, make
%   sure they're actually in your table though
%   month = choose which month will get indexed in the table
function rate = spline_diff_opt(T,country_array,month)
% initializing a row vector containing years for which data is available
% Note: 2020 data was not sufficient for some Middle Eastern countries
year = 1995:2019;
% although not needed typically, these arrays were created because in some
% cases MATLAB would not work without them :(
rate_array = ones(length(country_array),2);
% a loop that will index into every country's in the string array
for i=1:length(country_array)
    % Using logical indexing and string comparison for the string array
    % that must be passed into the function, this code will return the
    % indices of the matching criteria of country and month, which can be
    % specified outside the function
    index = find(strcmp(country_array(i), T.Country) &  T.Month == month);
    % Here is where I store the indexed data
    indexed_data = T(index,:);
    % Another loop where I extract the indices of the values in the average temperature
    % column. These indices are then used to generate another table to then convert it to an array,
    % where I take the mean of the array. This is the average temperature
    % for the month.
    for j=1:length(year)
        year_avg(j) = mean(table2array(indexed_data(find(indexed_data.Year==(1994+j)),8)));
    end
    % DIFFERENTIATION
    % Here I make use of the gradient() command since I have evenly-spaced
    % data!
    myderivative = gradient(year_avg, 1);
    % Used this command so that you get 6 figures
    figure()
    %subplot  (3,2,i)
    % plotting the derivative to see how rate of temperature change changes
    % over time
    plot(year, myderivative,'o')
    hold on
    title(country_array(i) + '''s Rate of Temp of Change vs Time(years)')
    xlabel('Years 1995 to 2019'), ylabel('Change in Temp per Year')
    % creating a piecewise interpolating polynomial from the data using PCHIP
    % to model physical phenomena correctly
    f = @(xx) interp1(year,myderivative, xx,'PCHIP');
    % plotting piecewise polynomial
    fplot(f,[1995 2019]);
    % OPTIMIZATION
    % using fminbnd() on the negative version of my piecewise polynomial to
    % find where the rate of temperature change is highest
    [xmax, negFmax] = fminbnd(@(xx) -f(xx), 2005,2019);
    % storing these years in an array in order to create a neat table!
    rate_array(i,1) = xmax; rate_array(i,2) = -negFmax;
    % coverting to table and concatenating a column of the countries
    rate = array2table([country_array' rate_array]);
    % adding variables names to the table
    rate.Properties.VariableNames = {'Country' 'Year' 'Temp Rate (°F/yr)'};
end
rate
end