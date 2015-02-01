function[A,B,C,D,E,F] = smoothEdge(A_r,B_r,C_r,D_r,E_r,F_r,OPT)
    if OPT == 'H'
        COMP = abs(A_r(2,1,1) - A_r(3,1,1));
    elseif OPT == 'V'
        COMP = abs(A_r(1,2,1) - A_r(1,3,1));
    end
    if COMP > 25
        A = mean(A_r);
        B = mean(B_r);
        C = mean(C_r);
        D = mean(D_r);
        E = mean(E_r);
        F = mean(F_r);
    else
        A = A_r(1,1,:);
        B = B_r(1,1,:);
        C = C_r(1,1,:);
        D = D_r(1,1,:);
        E = E_r(1,1,:);
        F = F_r(1,1,:);
    end
end