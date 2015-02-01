function [frames] = interweave(i_frames,p_frames,b_frames)
    frames{1} = i_frames{1};
    frames{2} = p_frames{1};
    frames{3} = b_frames{1};
    frames{4} = b_frames{2};
    delay = 0;
    for i = 1 : 5
        frames{2 * i + delay + 3} = p_frames{i + 1};
        frames{2 * i + delay + 4} = b_frames{i + delay + 2};
        frames{2 * i + delay + 5} = b_frames{i + delay + 3};
        delay = delay + 1;
    end
    frames{20} = p_frames{7};
    frames{21} = b_frames{13};
end