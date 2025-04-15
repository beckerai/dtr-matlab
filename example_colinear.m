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

X = cell(2, 1);
X{1} = [(0:3)', 2 * (0:3)' + 2];  % Colinear
X{2} = [0, 0; 0, 1; 1, 1; 1, 0];  % Not colinear

Y = cell(2, 1);
Y{1} = (1:4)';
Y{2} = (1:4)';

dtr(X, Y);

% Running this script will produce two warnings and one error.
% The output will look like this:
%
%     Find transforms for alignment of all pairs in M.
%         Find transform that aligns M2 to M1.
%     Warning: Rank deficient, rank = 2, tol =  1.776357e-15. 
%     > In get_transform (line 19)
%     In dtr (line 58)
%     In example_colinear (line 44)
% 
%         Find transform that aligns M1 to M2.
%     Warning: Rank deficient, rank = 2, tol =  1.776357e-15. 
%     > In get_transform (line 19)
%     In dtr (line 60)
%     In example_colinear (line 44)
% 
%     Calculate all possible pairwise DT similarities.
%         Calculate DT similarity of M1 and M2 aligned to M1.
%     Error using delaunay
%     Error computing the Delaunay triangulation. The points may be collinear.
% 
%     Error in dts (line 18)
%     D1 = delaunay(M1);
% 
%     Error in dtr (line 84)
%                 gamma_pairwise(ii, jj) = dts(M_ii, M_jj);
% 
%     Error in example_colinear (line 44)
%     dtr(X, Y);
