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

function [] = check_c(C)

if C == 3
    warning([ ...
        'Number of classes is 3, and thus each Delaunay ' ...
        'triangulation (DT) consists of only one triangle. This ' ...
        'usually allows for a perfect alignment of all DTs. The ' ...
        'resulting DT robustness (DTR) is likely to be 100. Use ' ...
        '''dtr_plot'' to see what we mean by this.']);
end

end
