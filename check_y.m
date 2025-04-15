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

function [] = check_y(Y)

if ~iscell(Y) || ~isvector(Y)
    error('Y must be a one-dimensional cell array.');
end

if any(cellfun(@(e) ~isnumeric(e) || ~isvector(e) || size(e, 2) ~= 1, Y))
    error('Elements of Y (label vectors) must be numeric column vectors.');
end

C = numel(unique(Y{1}));  % Number of classes or clusters
if any(cellfun(@(e) numel(unique(e)) ~= C, Y))
    error('Elements of Y (label vectors) must contain the same number of labels.');
end

if any(cellfun(@(e) any(unique(e) ~= (1:C)'), Y))
    error('Elements of Y (label vectors) must contain values from 1 to the number of labels.');
end

end
