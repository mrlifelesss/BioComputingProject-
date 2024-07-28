% Generate all possible input combinations
[x, y] = meshgrid(0:2, 0:2);
inputs = [x(:), y(:)];

% Generate all possible output combinations
outputs = dec2bin(0:511, 9) - '0';

% Create a 3D matrix to store all truth tables
% Dimensions: 9 rows (input combinations) x 3 columns (x, y, output) x 512 functions
truth_tables = zeros(9, 3, 512);

% Fill the truth tables matrix
for i = 1:512
    % Create the truth table for this function
    truth_table = [inputs, outputs(i, :)'];
    
    % Sort the truth table by x, then y
    truth_table = sortrows(truth_table, [1 2]);
    
    % Store this truth table in the 3D matrix
    truth_tables(:, :, i) = truth_table;
end

% Find functions where f(0,2) = 0
zero_at_02 = squeeze(truth_tables(3, 3, :)) == 0;

% Create a new matrix with only the functions where f(0,2) = 0
truth_tables_zero_02 = truth_tables(:, :, zero_at_02);

% Do the same for all functions  where f(2,0) = 1;
one_at_20 = squeeze(truth_tables_zero_02(7, 3, :)) == 1;
truth_tables_one_20 = truth_tables_zero_02(:, :, one_at_20);

% Check monotonicity of activators  for all functions
is_monotonic = false(1, 128);
for i = 1:128
    is_monotonic(i) = check_monotonicity(truth_tables_one_20(:,:,i));
end


% Create a new matrix with only the monotonic functions
truth_tables_monotonic = truth_tables_one_20(:, :, is_monotonic);

% Check antitonicity of inhibitors  for all functions
is_antitonic = false(1, 36);
for i = 1:36
    is_antitonic(i) = check_antitonicity(truth_tables_monotonic(:,:,i));
end

% Create a new matrix with only the antitonic functions
truth_tables_antitonic = truth_tables_monotonic(:, :, is_antitonic);

% Display results
disp('All truth tables have been generated and stored in the truth_tables matrix.');
disp(['Number of Repressable functions ', num2str(sum(zero_at_02))]);
disp(['Number of Repressable, Inducible functions ', num2str(sum(one_at_20))]);
disp(['Number of Repressable, Inducible,Monotonic of activators functions ', num2str(sum(is_monotonic))]);
disp(['Number of Repressable, Inducible,Monotonic of activators,Antitonic of inhibitors functions ', num2str(sum(is_antitonic))]);
disp('For each function: Column 1 = x, Column 2 = y, Column 3 = output');
disp('x reperests the 3 modes of activators - 0 = all off, 1 = some on,2 all on')
disp('j reperests the 3 modes of depressros - 0 = all off, 1 = some on,2 all on')
truth_tables_final = truth_tables_antitonic;


% Create the 18x9 chart
chart = zeros(18, 9);

for i = 1:18
    % Extract the output column (3rd column) for each function
    outputs = truth_tables_final(:, 3, i);
    
    % Convert to binary (1 if > 0, 0 otherwise) and transpose
    chart(i, :) = (outputs > 0)';
end

% Create headers
headers = {'(0,0)', '(0,1)', '(0,2)', '(1,0)', '(1,1)', '(1,2)', '(2,0)', '(2,1)', '(2,2)'};

% Create a table with headers
T = array2table(chart, 'VariableNames', headers);

% Add a row number column
T.Properties.RowNames = cellstr(num2str((1:height(T))', 'Function %d'));

% Write to CSV file
filename = 'function_chart.csv';
writetable(T, filename, 'WriteRowNames', true);

% Display confirmation
disp(['Chart has been saved to ', filename, ' with headers']);

% Display the chart in MATLAB command window
disp('Chart of functions (1 if output > 0, 0 otherwise):');
disp('Rows represent different functions, columns represent input combinations');
disp(T);disp(['Chart has been saved to ', filename, ' with red highlighting for 1s']);