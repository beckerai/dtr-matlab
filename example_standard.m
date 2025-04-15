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

method = 'TSNE';
init = 'random';  % 'random' or 'pca'

load([method, '_INIT', init, '_new.mat'], 'X', 'Y');

[dtr_score, dtr_std, dtr_struct] = dtr(X, Y);

fprintf('Method: %s\n', method);
fprintf('Initialization: %s\n', init);
fprintf('Delaunay triangulation robustness: ');
fprintf('%d \x00B1 %d\n', round(dtr_score), round(dtr_std));

figure;
dtr_plot(dtr_struct);
