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

% Get data
load([method, '_INIT', init, '.mat'], 'X', 'Y');
K = numel(X);  % Number of representations
C = numel(unique(Y{1}));  % Number of classes or clusters

% Preprocess data
% This is what dtr(X, Y) does under the hood
for ii = 1:K
    X{ii} = normalize(X{ii}, 'zscore', 'std');
end

% Determine representative points
% This is what dtr(X, Y) does under the hood
M = repmat({nan(C, 2)}, K, 1);
for ii = 1:K
    for cc = 1:C
        M{ii}(cc, :) = mean(X{ii}(Y{ii} == cc, :));
    end
end

[dtr_score, dtr_std, dtr_struct] = dtr(M);

fprintf('Method: %s\n', method);
fprintf('Initialization: %s\n', init);
fprintf('Delaunay triangulation robustness: ');
fprintf('%d \x00B1 %d\n', round(dtr_score), round(dtr_std));

% Apply DTR-based alignment to the data
Q = dtr_struct.Q;
for ii = 1:K
    X{ii} = transform(X{ii}, Q{ii});
end

% Plot
figure;
dtr_plot(dtr_struct, X, Y);
figure;
dtr_plot(dtr_struct, X);
figure;
dtr_plot(dtr_struct);

% This also works
% Apply DTR-based alignment to M first
for ii = 1:K
    M{ii} = transform(M{ii}, Q{ii});
end
figure;
dtr_plot(M, X, Y);
% figure;
% dtr_plot(M, X);
% figure;
% dtr_plot(M);

% This also works
M = dtr_struct.M;  % No need to apply the transform yourself
figure;
dtr_plot(M, X, Y);
% figure;
% dtr_plot(M, X);
% figure;
% dtr_plot(M);
