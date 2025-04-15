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

function [varargout] = dtr(varargin)
%DTR Delaunay triangulation-based robustness.

narginchk(1, 2);
nargoutchk(0, 3);

switch nargin
    case 1
        X = [];
        Y = [];
        M = varargin{1}(:);
        check_m(M);
        
        K = numel(M);  % Number of representations
        C = size(M{1}, 1);  % Number of classes or clusters or vertices
    case 2
        X = varargin{1}(:);
        Y = varargin{2}(:);
        check_x(X);
        check_y(Y);
        check_x_and_y(X, Y);
        
        K = numel(X);  % Number of representations
        C = numel(unique(Y{1}));  % Number of classes or clusters
        
        % Standardize elements of X
        % Calculate class centroids for each X, Y
        M = repmat({nan(C, 2)}, K, 1);
        for ii = 1:K
            X{ii} = normalize(X{ii}, 'zscore', 'std');
            for cc = 1:C
                M{ii}(cc, :) = mean(X{ii}(Y{ii} == cc, :));
            end
        end
end

check_c(C);

fprintf('Find transforms for alignment of all pairs in M.\n');
Q = repmat({eye(3)}, K, K);
for ii = 1:K
    for jj = (ii + 1):K
        fprintf('\tFind transform that aligns M%d to M%d.\n', jj, ii);
        Q{ii, jj} = get_transform(M{ii}, M{jj});
        fprintf('\tFind transform that aligns M%d to M%d.\n', ii, jj);
        Q{jj, ii} = get_transform(M{jj}, M{ii});
    end
end

gamma_mean = nan(K, 1);  % gamma denotes the DT similarity in our paper
gamma_std = nan(K, 1);
gamma_pairwise_all = cell(K, 1);

% -------------------------------------------------------------------
% Purpose of these loops:
%  - Fix M{kk} -> alignment reference
%  - Align M{ii} and M{jj} to M{kk}
%  - Collect pairwise gammas of M{ii} and M{jj} for ii ~= jj
%  - Calculate mean and std
%  - Store all pairwise gammas
% -------------------------------------------------------------------
fprintf('Calculate all possible pairwise DT similarities.\n');
for kk = 1:K
    gamma_pairwise = nan(K, K);
    for ii = 1:K
        M_ii = transform(M{ii}, Q{kk, ii});
        for jj = (ii + 1):K
            M_jj = transform(M{jj}, Q{kk, jj});
            fprintf('\tCalculate DT similarity of M%d and M%d aligned to M%d.\n', ii, jj, kk);
            gamma_pairwise(ii, jj) = dts(M_ii, M_jj);
        end
    end
    
    gamma_mean(kk) = mean(gamma_pairwise(:), 'omitnan');
    gamma_std(kk) = std(gamma_pairwise(:), 'omitnan');
    gamma_pairwise_all{kk} = gamma_pairwise;
end

% Find best gamma mean
% Get the index of alignment reference, too
[dtr_score, index] = max(gamma_mean);

varargout{1} = dtr_score;

if nargout >= 2
    dtr_std = gamma_std(index);
    varargout{2} = dtr_std;
end

if nargout == 3
    dtr_struct = struct();
    
    dtr_struct.index = index;
    
    dtr_struct.gamma_pairwise = gamma_pairwise_all{index};
    dtr_struct.gamma_pairwise_all = gamma_pairwise_all;
    
    dtr_struct.Q = Q(index, :);
    dtr_struct.O_all = Q;
    
    for ii = 1:K
        if ~isempty(X)
            X{ii} = transform(X{ii}, Q{index, ii});  %#ok<AGROW>
        end
        M{ii} = transform(M{ii}, Q{index, ii});
    end
    dtr_struct.X = X;
    dtr_struct.Y = Y;
    dtr_struct.M = M;
    
    dtr_struct.K = K;
    dtr_struct.C = C;
    
    varargout{3} = dtr_struct;
end

end
