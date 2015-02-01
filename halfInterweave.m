function [frames] = halfInterweave(i_frames,p_frames,b_frames)
    frames{1} = i_frames{1};
    frames{2} = p_frames{1};
    frames{3} = b_frames{1};
    frames{4} = b_frames{2};
    delay = 0;
    for i = 1 : 2
        frames{2 * i + delay + 3} = p_frames{i + 1};
        frames{2 * i + delay + 4} = b_frames{i + delay + 2};
        frames{2 * i + delay + 5} = b_frames{i + delay + 3};
        delay = delay + 1;
    end
    frames{11} = p_frames{4};
end