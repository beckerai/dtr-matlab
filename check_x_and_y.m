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

function [] = check_x_and_y(X, Y)

if numel(X) ~= numel(Y)
    error('X and Y must have the same number of cells.');
end

if any(cellfun(@(e1, e2) size(e1, 1) ~= size(e2, 1), X, Y))
    error('Elements of X (data matrices) and Y (label vectors) must match their number of rows.');
end

end
