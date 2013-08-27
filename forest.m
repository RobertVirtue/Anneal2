global slist sx sy
t = evalin('base','times');
p = evalin('base','power');
zt = t - t(1);
figure('Name','Solar','KeyPressFcn',@kbSolarGen)

plot(zt, p, '-b.')
