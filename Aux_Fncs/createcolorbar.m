function createcolorbar(axes1)
%CREATECOLORBAR(AXES1)
%  AXES1:  colorbar axes

%  Auto-generated by MATLAB on 06-Apr-2017 16:20:53

% Create colorbar
colorbar('peer',axes1);

labels = get(bar_handle, 'yticklabel');
barlabels = cell(size(labels, 1), 1);
for i=1:size(labels, 1)
    barlabels{i} = ['10^{', labels{i}, '}'];
end
set(bar_handle, 'yticklabel', char(barlabels), 'FontWeight', 'bold', 'fontsize', 10)
ylabel(bar_handle, 'Differential energy flux')