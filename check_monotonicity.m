% Function to check monotonicity condition
function is_monotonic = check_monotonicity(truth_table)
is_monotonic = true;
for y = 0:2
    for x = 0:2
        % Find the row index where x and y match the desired values
        row_index = find((truth_table(:, 1) == x) & (truth_table(:, 2) == y));
        % Extract the result from the matching row
        result = truth_table(row_index, 3);
        if result == 1
            for z = 1:2
                if z+ x > 2
                    break
                end
                % Find the row index where x+z and y match the desired values
                row_index = find((truth_table(:, 1) == x+z) & (truth_table(:, 2) == y));
                % Extract the result from the matching row
                result = truth_table(row_index, 3);
                if result == 0
                    is_monotonic = false;
                    return;
                end
            end
        end
    end
end
end