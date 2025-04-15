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

function [] = check_x(X)

if ~iscell(X) || ~isvector(X)
    error('X must be a one-dimensional cell array.');
end

if any(cellfun(@(e) ~isnumeric(e) || ~ismatrix(e), X))
    error('Elements of X (data matrices) must be numeric matrices.');
end

if any(cellfun(@(e) size(e, 2) ~= 2, X))
    error('Elements of X (data matrices) must be have 2 columns.');
end

end
