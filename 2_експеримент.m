%% КРОК 1: Генерація сигналу x(t) = sin(2πt)
Fs = 50;                  % Частота дискретизації, 50 Гц
T = 2.5;                  % Тривалість сигналу, 2.5 сек
t = 0 : 1/Fs : T;         % Шкала часу
x = sin(2*pi*t);          % Сигнал x(t)

% Бажаний вихід: y(t) = 2x(t) + 3
d = 2 * x + 3;

%% КРОК 2: Формування вхідної матриці з затримкою (почнемо з 2 блоків)
delay = 2;

X = zeros(length(x), delay + 1);
for i = 1:length(x)
    for j = 0:delay
        if i - j > 0
            X(i, j + 1) = x(i - j);
        else
            X(i, j + 1) = 0;
        end
    end
end

%% КРОК 3: Навчання мережі
% Початкові ваги
w = zeros(1, delay + 1);
eta = 0.01;             % Швидкість навчання
epochs = 100;

% Масив для збереження помилки на кожній епосі
error_plot = zeros(1, epochs);

for epoch = 1:epochs
    mse = 0;
    for i = 1:length(x)
        y = dot(w, X(i, :));          % Поточний вихід
        e = d(i) - y;                 % Помилка
        mse = mse + e^2;             % Накопичення MSE
        w = w + eta * e * X(i, :);   % Оновлення ваг
    end
    error_plot(epoch) = mse / length(x);  % Середньоквадратична помилка за епоху
end

% Передбачений вихід після навчання
y_pred = X * w';

%% КРОК 4: Побудова графіка помилки за епохами
figure;
plot(1:epochs, error_plot, 'LineWidth', 2);
xlabel('Епоха');
ylabel('MSE');
title('Графік помилки під час навчання');
grid on;

%% КРОК 5: Аналіз впливу кількості блоків затримки
maxDelay = 10;
mse_by_delay = zeros(1, maxDelay + 1);

for delay = 0:maxDelay
    % Формування нової матриці входів
    X = zeros(length(x), delay + 1);
    for i = 1:length(x)
        for j = 0:delay
            if i - j > 0
                X(i, j + 1) = x(i - j);
            else
                X(i, j + 1) = 0;
            end
        end
    end

    % Ініціалізація ваг і параметрів
    w = zeros(1, delay + 1);
    eta = 0.01;
    epochs = 100;

    % Навчання
    for epoch = 1:epochs
        for i = 1:length(x)
            y = dot(w, X(i, :));
            e = d(i) - y;
            w = w + eta * e * X(i, :);
        end
    end

    % Розрахунок остаточної помилки
    y_pred = X * w';
    mse_by_delay(delay + 1) = mean((d - y_pred').^2);
end

% Побудова графіка залежності помилки від кількості блоків затримки
figure;
plot(0:maxDelay, mse_by_delay, '-o', 'LineWidth', 2);
xlabel('Кількість блоків затримки');
ylabel('Середньоквадратична помилка (MSE)');
title('Вплив кількості блоків затримки на точність');
grid on;