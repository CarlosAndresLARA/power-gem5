close all
clear 
clc

ts = 1.0E-5;

clock = load('s/system.cpu_cluster.clk_domain.clock_part00.csv');
clock_n = clock/max(clock);
clock_t = load('t/system.cpu_cluster.clk_domain.clock_part00.csv');

voltage = load('s/system.cpu_cluster.l2.power_model.staticPower_part00.csv');
voltage_n = voltage/max(voltage);
voltage_t = load('t/system.cpu_cluster.l2.power_model.staticPower_part00.csv');

ipc = load('s/system.cpu_cluster.cpus.ipc_part00.csv');
ipc_n = ipc/max(ipc);
ipc_t = load('t/system.cpu_cluster.cpus.ipc_part00.csv');

overallMisses = load('s/system.cpu_cluster.cpus.dcache.overallMisses::total_part00.csv');
overallMisses_n = overallMisses/max(overallMisses);
overallMisses_t = load('t/system.cpu_cluster.cpus.dcache.overallMisses::total_part00.csv');


n = max([length(clock_t), length(voltage_t),length(ipc_t),length(overallMisses_t)]);

c = zeros(1,n);
v = zeros(1,n);
i = zeros(1,n);
o = zeros(1,n);

c(clock_t) = clock;
v(voltage_t) = voltage;
i(ipc_t) = ipc;
o(overallMisses_t) = overallMisses;

dynamic = v .* ((2 * i) + (3 * 0.000000001 * o));
dynamic_n = dynamic/max(dynamic);

cmap = lines(7);

figure
hold on
plot((1:n)*ts,clock_n,'-','Color',cmap(1,:),'LineWidth',2)
plot(voltage_t*ts,voltage_n,'--','Color',cmap(3,:),'LineWidth',2)
plot(ipc_t*ts,ipc_n,'s','Color',cmap(2,:))
plot(overallMisses_t*ts,overallMisses_n,'d','Color',cmap(4,:))
xlim([1.05 1.1])
ylim([-0.1 1.4])
legend('clock period','core voltage', 'core IPC', 'd-cache overallMisses')
grid on
box off
xlabel('Time (s)')
ylabel('Normalized amplitude')

figure
hold on
plot((1:10:n)*ts,clock_n(1:10:n),'-','Color',cmap(1,:),'LineWidth',2)
plot(voltage_t(1:10:n)*ts,voltage_n(1:10:n),'--','Color',cmap(3,:),'LineWidth',2)
plot((1:10:n)*ts,dynamic_n(1:10:n),'.','Color',cmap(5,:))
xlim([0 n*ts])
ylim([-0.1 1.4])
legend('clock period', 'core voltage','dynamic power')
grid on
box off
xlabel('Time (s)')
ylabel('Normalized amplitude')
