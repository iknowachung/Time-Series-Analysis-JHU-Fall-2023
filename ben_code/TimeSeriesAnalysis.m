
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
data_table.date = datetime(data_table.time_tag,'InputFormat','yyyy-MM');
