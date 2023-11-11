% json file sourced from:
%   https://www.swpc.noaa.gov/products/solar-cycle-progression

fid = fopen('../data/observedSolarCycleIndices.json'); % Opening the file
raw = fread(fid,inf); % Reading the contents
str = char(raw'); % Transformation
fclose(fid); % Closing the file
data = jsondecode(str); % Using the jsondecode function to parse JSON from string
data_table = struct2table(data);

fid = fopen('../data/predicted-solar-cycle.json'); % Opening the file
raw = fread(fid,inf); % Reading the contents
str = char(raw'); % Transformation
fclose(fid); % Closing the file
data = jsondecode(str); % Using the jsondecode function to parse JSON from string
noaa_pred_data_table = struct2table(data);

% Change to "datetime" datatype
%   Assumes 1st of the month for each time stamp
T = datetime(data_table.time_tag,'InputFormat','yyyy-MM');

% NOAA predictions
T_pred = datetime(noaa_pred_data_table.time_tag,'InputFormat','yyyy-MM');

% indices for training and test data 1950 <= year(T)) & 
iTrain = ((1900 <= year(T)) & (year(T) <= 1990));
iPredict = (year(T) > 1990);

% Splitting data table into training and test
training_data = data_table(iTrain,:);
T_train = datetime(training_data.time_tag,'InputFormat','yyyy-MM');
test_data = data_table(iPredict,:);
T_test = datetime(test_data.time_tag,'InputFormat','yyyy-MM');

% Plot ACF
figure;
subplot(2,1,1);
autocorr(training_data.ssn);
title('Autocorrelation Function (ACF)');

% Plot PACF
subplot(2,1,2);
parcorr(training_data.ssn);
title('Partial Autocorrelation Function (PACF)');
