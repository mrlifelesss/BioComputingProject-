% Function to check antitonicity condition with respect to y
function is_antitonic = check_antitonicity(truth_table)
is_antitonic = true;
for x = 0:2
    for y = 0:1
        % Find the row index where x and y match the desired values
        row_index = find((truth_table(:, 1) == x) & (truth_table(:, 2) == y));
        % Extract the result from the matching row
        result = truth_table(row_index, 3);
        if result == 0
            for z = 1:2
                if z+ y > 2
                    break
                end
                % Find the row index where x and y+z match the desired values
                row_index = find((truth_table(:, 1) == x) & (truth_table(:, 2) == y+z));
                % Extract the result from the matching row
                result = truth_table(row_index, 3);
                if result == 1
                    is_antitonic = false;
                    return;
                end
            end
        end
    end
end
end