
% json file sourced from:
%   https://www.swpc.noaa.gov/products/solar-cycle-progression

fid = fopen('../data/observedSolarCycleIndices.json'); % Opening the file
raw = fread(fid,inf); % Reading the contents
str = char(raw'); % Transformation
fclose(fid); % Closing the file
data = jsondecode(str); % Using the jsondecode function to parse JSON from string
data_table = struct2table(data);

% Change to "datetime" datatype
%   Assumes 1st of the month for each time stamp
T = datetime(data_table.time_tag,'InputFormat','yyyy-MM');

Mdl = arima('Constant',0,'D',1,...
    'Seasonality',12,...
    'ARLags',1','SARLags',12', ...
    'MALags',1','SMALags',12);
EstMdl = estimate(Mdl,data_table.ssn);

residuals = infer(EstMdl,data_table.ssn);
prediction = data_table.ssn-residuals;
figure()
plot(T,data_table.ssn)
hold on
plot(T,prediction)
legend({'Observed','Predicted'},'Location','best')