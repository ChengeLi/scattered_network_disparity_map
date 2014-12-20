function cost = get_matching_cost(img_left, left_feature, right_feature, kSample)

    template_size = 2 ^ kSample;
    [height, width] = size(img_left);
    new_width = floor(width / template_size);
    new_height = floor(height / template_size);

    cost = cell(new_height, 1);

    % % consider each row
    cost_each_Row = zeros(new_width, new_width);

    for i = template_size / 2 : template_size : height
        for j = template_size / 2 : template_size : width

    % %         center_left=[i,j];
    % %         
    % %         center_right=[i,j];
    % %         
    % %         % define the matching cost as the scatter_template error between 
    % % %left_scatter_template centered at (i,j) and right_scatter_template centered at (i,round(j-d_lnew))
    % %         
    % %         cost((i+16)/32,(j+16)/32)=sca_temp_error_full(left_vector_full,right_vector_full,center_left,center_right);
            center_left = [i, j];    
            for k = template_size / 2 : template_size : width
                center_right = [i, k];
                % define the matching cost as the scatter_template error between 
                % left_scatter_template centered at (i,j) and right_scatter_template 
                % centered at (i,round(j-d_lnew))
                cost_each_Row((j + template_size / 2) / template_size, ...
                              (k + template_size / 2) / template_size) = ...
                get_scatter_network_temp_error(left_feature, right_feature, center_left, center_right, img_left, kSample);
            end
            cost{(i + template_size / 2) / template_size, 1} = cost_each_Row;
        end
    end
end
