% Copyright 2025 Martin Becker
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%      http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.

function [gamma] = dts(M1, M2)
% DTS Delaunay triangulation-based similarity.

D1 = delaunay(M1);
D2 = delaunay(M2);

D = [D1; D2];
D = sort(D, 2);
D = sortrows(D);

[unique_triangles, ~, backward_indices] = unique(D, 'rows');
num_unique_triangles = size(unique_triangles, 1);

% Calculate alpha:
% Percentage of common triangles
is_common_triangle = nan(num_unique_triangles, 1);
for tt = 1:num_unique_triangles
    is_common_triangle(tt) = sum(backward_indices == tt) == 2;
end
num_common_triangles = sum(is_common_triangle);
if num_common_triangles == 0
    alpha = 0;  
else
    alpha = num_common_triangles / num_unique_triangles * 100;
end

% Calculate beta:
% Average percental overlap of the common triangles
if num_common_triangles == 0
    beta = 0;
else
    overlap = 0;
    for tt = 1:num_unique_triangles
        if is_common_triangle(tt)
            indices = unique_triangles(tt, :);
            P1 = polyshape(M1(indices, :));
            P2 = polyshape(M2(indices, :));
            
            % Accumulate intersection over union (IoU)
            area_intersect = area(intersect(P1, P2));
            area_union = area(union(P1, P2));
            iou = area_intersect / area_union;
            iou = min(1, iou);  % Plain IoU can be > 1 (numerical effects)
            overlap = overlap + iou;
        end
    end
    beta = overlap / num_common_triangles * 100;
end

% Calculate gamma:
% DT similarity
gamma = sqrt(alpha * beta);

if ~isnumeric(gamma) || ~isscalar(gamma) || isnan(gamma) || gamma < 0 || gamma > 100
    error(['Invalid DT similarity %f (value must lie between  0 and 100).\n' ...
        'Any error at this point indicates a bug.\n' ...
        'Please report it. Thank you in advance.'], gamma);
end

end
