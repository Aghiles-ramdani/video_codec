function stream = ZeroRunDec( encoded_stream )
    sizes = size(encoded_stream);
    j = 1;
    zeroed = false;
    EOB = 260;
    for i = 1 : sizes(2)
        if encoded_stream(i) == 0
            if i ~= sizes(2) & i > 1
                if encoded_stream(i + 1) ~= 0 && encoded_stream(i - 1) ~= 0
                    tmp = zeros(1,encoded_stream(i + 1));
                    stream(j) = 0;
                    stream(j + 1:j + encoded_stream(i + 1)) = tmp;
                    j = j + encoded_stream(i + 1) + 1;
                    zeroed = true;
                else
                    if encoded_stream(i + 1) ~= 0
                    else
                        stream(j) = 0;
                        j = j + 1;
                    end
                end
            else
                if i == 1
                    if encoded_stream(i + 1) ~= 0
                        tmp = zeros(1,encoded_stream(i + 1));
                        stream(j) = 0;
                        stream(j + 1:j + encoded_stream(i + 1)) = tmp;
                        j = j + encoded_stream(i + 1) + 1;
                        zeroed = true;
                    else
                        if encoded_stream(i + 1) ~= 0
                        else
                            stream(j) = 0;
                            j = j + 1;
                        end
                    end
                end
            end
        else
            if( ~zeroed && encoded_stream(i) ~= EOB )
                stream(j) = encoded_stream(i);
                j = j + 1;
            elseif (encoded_stream(i) == EOB)
                    tmp_j = ceil(j / 64);
                    next_eob = 64 * tmp_j;
                    n_trailing_zeroes = next_eob - j;
                    trailing_zeroes = zeros(1,n_trailing_zeroes);
                    stream(j) = 0;
                    stream = [stream trailing_zeroes];
                    j = j + n_trailing_zeroes + 1;
            else
                zeroed = false;
            end
        end
    end
end