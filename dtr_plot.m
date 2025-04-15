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

function [] = dtr_plot(varargin)

narginchk(1, 4);

if isstruct(varargin{1})
    dtr_struct = varargin{1};
    
    X = dtr_struct.X;  % Can be []
    Y = dtr_struct.Y;  % Can be []
    M = dtr_struct.M;
    
    K = dtr_struct.K;  % Number of representations
    C = dtr_struct.C;  % Number of classes or clusters or vertices
    
    if isempty(Y)
        cmap = repmat(lines(1), C, 1);
    else
        cmap = lines(C);
    end
else
    X = [];
    Y = [];
    
    M = varargin{1};
    check_m(M);
    
    K = numel(M);  % Number of representations
    C = size(M{1}, 1);  % Number of classes or clusters or vertices
    
    cmap = repmat(lines(1), C, 1);
end

if nargin >= 2
    % Overwrite data matrices
    X = varargin{2};  
    check_x(X);
    if numel(X) ~= K
        error('X and M (or dtr_struct.M) must have the same number of cells.');
    end
    
    % Overwrite label vectors
    Y = cell(K, 1);
    for ii = 1:K
        Y{ii} = ones(size(X{ii}, 1), 1);
    end
    
    % Just one color
    cmap = repmat(lines(1), C, 1);
end

if nargin >= 3
    Y = varargin{3};
    check_y(Y);
    check_x_and_y(X, Y);  % Checks numel(Y) ~= K through numel(X) ~= numel(Y)
    
    cmap = lines(C);
end

if nargin == 4
    cmap = varargin{4};
    if size(cmap, 1) < C
        error('cmap must provide one color per class/cluster/vertex');
    end
end

num_rows = ceil(sqrt(K));
num_cols = num_rows + 1;

design = {'FaceColor', 'none', 'EdgeColor', 0.5 * ones(3, 1)};

% Scatter plot and triangle meshes
for ii = 1:K
    idx = ii + floor((ii + floor(ii / num_cols)) / num_cols);
    subplot(num_rows, num_cols, idx, 'Tag', ['scatterplot_', num2str(ii)]);
    hold on;
    
    if ~isempty(X)
        scatter(X{ii}(:, 1), X{ii}(:, 2), [], cmap(Y{ii}, :), '.');
    end
    % Triangle mesh of Delaunay triangulation
    D = delaunay(M{ii});
    patch('Faces', D, 'Vertices', M{ii}, 'FaceColor', 'none');
    
    % 2D Delaunay stack
    idx = num_rows * num_cols;
    subplot(num_rows, num_cols, idx, 'Tag', 'delaunay_stack_2d');
    hold on;
    patch('Faces', D, 'Vertices', M{ii}, design{:});
    
    % 3D Delaunay stack
    idx = num_cols : num_cols : num_cols * (num_rows - 1);
    ax3d = subplot(num_rows, num_cols, idx, 'Tag', 'delaunay_stack_3d');
    hold on;
    z = ii * ones(size(M{ii}, 1), 1);
    patch('Faces', D, 'Vertices', [M{ii}, z], design{:});
end

% Add "perspective" to 3D Delaunay stack
view(ax3d, -15, 5);

% Links through Delaunay vertices
links = cat(3, M{:});
for cc = 1:C
    x = squeeze(links(cc, 1, :));
    y = squeeze(links(cc, 2, :));
    z = 1:K;
    
    % Delaunay stack design
    design = {'Color', cmap(cc, :), 'LineWidth', 2};
    
    % Delaunay stack 2D
    idx = num_rows * num_cols;
    subplot(num_rows, num_cols, idx);
    hold on;
    plot(x, y, design{:});
    
    % Delaunay stack 3D
    idx = num_cols:num_cols:(num_rows * num_cols - 1);
    subplot(num_rows, num_cols, idx);
    hold on;
    plot3(x, y, z, design{:});
end

end
