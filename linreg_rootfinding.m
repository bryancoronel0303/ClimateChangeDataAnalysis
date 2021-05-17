% THIS IS THE START OF A NEW FUNCTION
% linereg_footfinding: function stats = linreg_rootfinding(T,country_array,month,forecast_year)
%
% This function implements several numerical methods
% Employs linear regression using the power law model to forecast future
% temperatures. Uses root-finding to make a prediction of when a certain
% temperature will be reached
%
% output:
%   stats = table that contains statistical measurements of the model
%   used to see how well it fit the data
% input:
%   T = table of data that must be imported first
%   country_array = is a string array that contains country names, make
%   sure they're actually in your table though
%   month = choose which month will get indexed in the table
%   forecast_year = choose until what year you want plot your fitted
%   regression line to forecast some temperatures

function stats = linreg_rootfinding(T,country_array,month,forecast_year)
% initializing a row vector containing years for which data is available
% Note: 2020 data was not sufficient for some Middle Eastern countries
year = 1995:2019;
% although not needed typically, these arrays were created because in some
% cases MATLAB would not work without them :(
stats_array = ones(length(country_array),5);
death_year_array = ones(1,length(country_array));
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
    % Used this command so that you get 6 figures
    figure()
    % Here I created subplots, so that you can see all the data points
    % extracted with their respective fitted lines on top. Commented out
    % because of the way it outputs
    %subplot  (3,2,i)
    % Here I make use of the rmoutliers() command in case some years are
    % anomalies in terms of the overall climate
    [year_avg, remove_year] = rmoutliers(year_avg,'mean');
    % Clearing the value of the year where the anomaly appeared, so that
    % the dimensions of the matrices agree when performing regression
    year(remove_year==1)=[];
    % plot log(y) vs x
    plot(year,log(year_avg), 'o');
    % appropriate plot components
    title(country_array(i) + '''s Monthly Avg Temp vs Time(years)')
    xlabel('Years 1995 to 2019'), ylabel('Natural Log Monthly Avg Temp')
    hold on
    % LINEAR REGRESSION
    % power law model ln(y) = ln(a_0) + a_1*ln(x)
    % Here I initialized my matrices to least squares perform regression
    Z = [ones(length(year),1) log(year)']; y = (log(year_avg))'; coeff = Z\y;
    % I initiliazed some year values to make the fitted line look smoth
    xvals =  linspace(1995, forecast_year, 1000);
    % plotting my fitted line with appropriate components
    plot(xvals,coeff(1)+ coeff(2).*log(xvals)); 
    legend('Data Set Points', 'Fitted Line','Location', 'southeast')
    hold off
    format short
    % Here I make use of a loop to create an array to store some measure of
    % how good my fitted line is
    for k=1:5
        if (k==1)
            % sum of square residuals
            S_r = sum((y-Z*coeff).^2); stats_array(i,k) = S_r;
        end
        if (k==2)
            % standard error of estimate
            S_yx = sqrt( S_r /(length(year)-length(coeff))); stats_array(i,k) = S_yx;
        end
        if (k==3)
            % total sum of squares
            S_t = sum((y - mean(y)).^2); stats_array(i,k) = S_t;
        end
        if (k==4)
            %coefficient of determination
            r_squared = 1 - (S_r/S_t); stats_array(i,k) = r_squared;
        end
        if (k==5)
            % correlation coefficient
            r = sqrt(r_squared); stats_array(i,k) = r;
        end
    end
    % To make for cleaner output, I converted it to a table
    stats_table = array2table(stats_array);
    % concatenated a column containing the country names
    stats = [array2table(country_array'), stats_table];
    % adding variable names to table
    stats.Properties.VariableNames = {'Country' 'S_r' 'S_yx' 'S_' 'R^2' 'R'};
    % ROOT-FINDING
    % initializing the temperature at which living in for multiple
    % consecutive days can be deadly!
    death_temp = 98;
    % creating an array where I store the root of setting my fitted
    % regression model equal to the deadly temperature. Recall my dependent
    % variable must have exp() used on it, given I linearized my model
    death_year_array(i) = exp(roots([coeff(2), coeff(1)-log(death_temp)]));
    death_year = array2table([country_array' death_year_array']);
    % adding variable names to table
    death_year.Properties.VariableNames = {'Country' 'Fatal Year'};
end
% If plotting using subplot(), uncomment 
% sgtitle('Power Law Model: $$ ln(y) = ln(a_{0}) + a_{1}\ast ln(x)$$','interpreter', 'latex')
% not supressing my table
death_year
end

% Note: Here is the code I constructed to test other models out. They will
% not be a part of my output because they are not the final model I ended
% up choosing!
% linear model
%Z = [ones(length(year),1) year']; y = year_avg'; coeff = Z\y;
%xvals = linspace(1995,forecast_year , 1000);
%plot (xvals, coeff(1)+coeff(2).*xvals)

% saturation kinetics
%Z = [ones(length(year),1) (1./year)']; y = (1./year_avg)'; coeff = Z\y;
%xvals = linspace(1995, forecast_year, 1000); yvals = coeff(1) + coeff(2).* (1./xvals);
%plot(xvals, yvals)

% exponential model
%Z = [ones(length(year),1) year']; y = (log(year_avg))'; coeff = Z\y;
%xvals = linspace(1995, forecast_year, 1000); yvals = coeff(1) + coeff(2).*xvals;
%plot(xvals, yvals);