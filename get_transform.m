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

function [Q] = get_transform(M1, M2)

M1 = [M1, ones(size(M1, 1), 1)];
M2 = [M2, ones(size(M2, 1), 1)];
Q = M2 \ M1;  % Minimize || M1 - M2 * Q ||^2

end
