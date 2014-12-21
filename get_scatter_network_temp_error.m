
function sca_error_cost = get_scatter_network_temp_error(left_vector_full, right_vector_full, ...
                                              center_left, center_right, img_left, kSample)

                         
                                          
    template_size = 2 ^ kSample;
    [height, width] = size(img_left); 
    a = template_size / 2;
    b = a - 1;
    error=0;
    % check right location validality 
    if (center_right(2) <= b) || (center_right(2) >= width - b)   %if the rigth template center is out of scope, inf
        sca_error_cost = inf;
    else 
        for l = 1 : size(left_vector_full, 1)
            lth_vector_left = left_vector_full{l};
            lth_vector_right = right_vector_full{l};

            left = lth_vector_left(center_left(1) - b : center_left(1) + a, center_left(2) - b : center_left(2) + a);
            right = lth_vector_right(center_right(1) - b : center_right(1) + a, center_right(2) - b : center_right(2) + a);

            error_templ = (left - right) .^ 2;
            error = error + sum(sum(error_templ)) / (template_size ^ 2);
        end
        sca_error_cost = error / size(left_vector_full, 1);
    end

end
