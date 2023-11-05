% DATA CLEANING/PREPROCESSING

% reading data in and formatting into a single data_table
sun_spots = readtable('../data/sunspots.csv');
solar_wind = readtable('../data/solar_wind.csv');
dst_labels = readtable('../data/dst_labels.csv');

% joining features on timedelta
data_table = outerjoin(sun_spots, solar_wind,"Keys", "timedelta");
data_table = renamevars(data_table,"timedelta_solar_wind", "timedelta");
data_table = removevars(data_table, "timedelta_sun_spots");
data_table = outerjoin(data_table, dst_labels, "Keys", "timedelta");
data_table = removevars(data_table, "timedelta_dst_labels");
data_table = renamevars(data_table,"timedelta_data_table", "timedelta");
data_table = removevars(data_table, ["period_sun_spots", "period_solar_wind"]);

% casting bt to float
data_table.("bt") = cast(data_table.("bt"), 'single');

% sorting by timedelta from ascending (this is done to impute missing
% values (via forward fill and interpolation)
data_table = sortrows(data_table, "timedelta");

% forward fill smoothed_ssn
data_table.smoothed_ssn = fillmissing(data_table.smoothed_ssn, 'previous');


% linear interpolation on the datatable (can be adjsuted to another method)
data_table{:,{'bt','bx_gse','by_gse','bx_gsm',...
    'by_gsm','bz_gse','bz_gsm','density','phi_gse',...
    'phi_gsm','speed','temperature','theta_gse','theta_gsm'}} =...
fillmissing(data_table{:,{'bt','bx_gse','by_gse','bx_gsm',...
    'by_gsm','bz_gse','bz_gsm','density','phi_gse',...
    'phi_gsm','speed','temperature','theta_gse','theta_gsm'}},...
    'linear');

% will determine these steps later for now just put something down
p = 1; d = 1; q = 1;
P = 1; D = 1; Q = 1; S = 12; % Seasonal period (e.g., 12 for monthly data)


sarima_model = estimate(data_table, [p, d, q, P, D, Q, S]);
