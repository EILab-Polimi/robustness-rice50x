function [out] = dominated_rows(in)

% The function takes as input an array and gives as output a logical vector of the
% same length of the input array. The elements of the vector are 0 for a
% non-dominated row and 1 for a dominated row.
% 
% By Luca Ferrari - 13/07/2021


N = height(in);
M = size(in, 2);
out = zeros(N, 1);

for i = 1:N
    comp = in(i,:) < in;
    dom_check = sum(comp, 2);
    is_dom = find(dom_check==M, 1);
    if isempty(is_dom) == 0
        out(i,1) = 1;
    end
end

out = logical(out);

end