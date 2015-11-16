%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Applied Math/Engineering Sciences 121     %
% Extreme Optimization 2: Kidney Exchange   %
% Visualization script                      %
% Velina Kozareva - November 2015           %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

N = 10;   % enter number of patient-donor pairs here

% load exchange output from AMPL
[file,path,success] = uigetfile({'*.out;*.txt'},...
                                'Please select the exchange output file from AMPL, usually *.out');
if success
    exchange = importdata(strcat(path,file));
else
    error('EO2Visualizer:fileimport',...
          'Exchange output file selection error. Please try again. If the problem persists, contact the course staff.');
end

% load compatibility graph
[file,path,success] = uigetfile({'*.out;*.txt'},...
                                'Please select the compatibility data, usually *_raw.txt',...
                                path);
if success
    compat = importdata(strcat(path,file));
else
    error('EO2Visualizer:fileimport',...
          'Compatibility file selection error. Please try again. If the problem persists, contact the course staff.');
end

if (length(compat) ~= N || length(exchange) ~= N)
    error('Input matrix dimensions must match given number of patient-donor pairs. Please try again.')
end

% generate ring of points
Adj = (polygon(N, 2, 200)).';

cell = {exchange, compat};

for i = 1:2
    
[dxu, dyu, dxl, dyl, ux, uy] = gplotd(cell{i}, Adj);

% start points for each arrow (including double-ended)
startx = [ux(1:3:end).', ux(2:3:end).', dxu(1:3:end).',dxl(1:3:end).'].';
starty = [uy(1:3:end).', uy(2:3:end).', dyu(1:3:end).',dyl(1:3:end).'].';
starty(isnan(starty)) = [];
startx(isnan(startx)) = [];
start = [startx, starty];

% end points for each arrow (including double-ended)
stopx = [ux(2:3:end).', ux(1:3:end).', dxu(2:3:end).',dxl(2:3:end).'].';
stopy = [uy(2:3:end).', uy(1:3:end).', dyu(2:3:end).',dyl(2:3:end).'].';
stopy(isnan(stopy)) = [];
stopx(isnan(stopx)) = [];
stop = [stopx, stopy];

hold on
arrow(start, stop, 'BaseAngle', 60)
hold off
end 