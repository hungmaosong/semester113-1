% 已知參數
M0 = 1;          % M0(normalized to 1)
T1 = 1300;       % T1 relaxation time (ms)
T2 = 80;         % T2 relaxation time (ms)
TR = 1000;       % Repetition time (ms)
t_start = -TR;   % Start time (ms)
t_end = 4 * TR;  % End time (ms)

dt = 1;          % Time step (ms)
time = t_start:dt:t_end; % Time vector

% 初始化Mz、Mxy
Mz = zeros(size(time));
Mxy = zeros(size(time));

% Simulate RF pulse series and magnetization changes
for t_idx = 1:length(time) %依序處理時間範圍 time 中的每個時間點t，索引為 t_idx。
    t = time(t_idx); %獲取當前時間點 𝑡

    if t < 0 %  RF 脈衝開始前的範圍
        Mz(t_idx) = M0; %RF脈衝前，磁化處於熱平衡狀態
        Mxy(t_idx) = 0; % RF 脈衝未施加前，橫向磁化未被激發

    else % RF 脈衝後的情況 
        n = floor(t / TR); % 判斷在當前時間 t 已施加了多少次 RF 脈衝
        t_relax = t - n * TR; % 從上次 RF 脈衝到當前時間的間隔
        
        % Mz
        Mz(t_idx) = M0 * (1 - exp(-t_relax / T1));
        
        % Transverse magnetization decays quickly due to T2
        if t_relax == 0
            Mxy(t_idx) = M0; % t_relax == 0，剛好施加了一次 RF 脈衝，此時橫向磁化被激發到最大值 M0
        else
            Mxy(t_idx) = M0 * exp(-t_relax / T2); % t_relax > 0，T2 relaxation
        end
    end
end

% 作圖
figure;
subplot(2, 1, 1);
plot(time, Mz, 'b', 'LineWidth', 1.5);
xlabel('Time (ms)');
ylabel('M_z / M_0');
title('Longitudinal Magnetization (M_z)');
grid on;

subplot(2, 1, 2);
plot(time, Mxy, 'r', 'LineWidth', 1.5);
xlabel('Time (ms)');
ylabel('M_{xy} / M_0');
title('Transverse Magnetization (M_{xy})');
grid on;

sgtitle('Magnetization Dynamics over Time');
