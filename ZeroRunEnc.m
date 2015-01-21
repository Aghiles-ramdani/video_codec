function encoded_stream = ZeroRunEnc( stream )
    EOB = 260;
    sizes = size(stream);
    j = 1;
    zero_count = 0;
    for i = 1 : sizes(1)
        if stream(i) ~= 0
            if(zero_count > 0)
                j = j + 2;
            end
            encoded_stream(j) = stream(i);
            j = j + 1;
            zero_count = 0;
        else
            zero_count = zero_count + 1;
            if zero_count > 1
                encoded_stream(j + 1) = encoded_stream(j + 1) + 1;
                if(i == sizes (1) )
                    end_position = size(encoded_stream);
                    end_position = end_position(2) - 1;
                    encoded_stream = encoded_stream(1:end_position);
                    encoded_stream(end_position) = EOB;
                end
            else
                encoded_stream(j + 1) = 0;
                encoded_stream(j) = 0;
            end    
        end
    end
end