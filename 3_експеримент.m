%% КРОК 1: Формування сигналу x(t)
% Перша частина: 3 сек, 100 Гц, x(t) = sin(2πt)
Fs1 = 100;
t1 = 0:1/Fs1:3;
x1 = sin(2*pi*t1);

% Друга частина: 2 сек, 40 Гц, x(t) = sin(4πt)
Fs2 = 40;
t2 = t1(end) + 1/Fs2 : 1/Fs2 : t1(end) + 2;
x2 = sin(4*pi*t2);

% Об'єднання часу та сигналу
t = [t1 t2];
x = [x1 x2];

% Вихідна цільова функція з затримкою: y(t) = 3 * x(t-1) + 1
% З урахуванням того, що крок дискретизації різний, змістимо на 1 крок
d = [0, 3 * x(1:end-1) + 1];  % Перший елемент нульовий, бо немає попереднього

%% КРОК 2: Створення матриці входів з 2-ма блоками затримки
delay = 2;
X = zeros(length(x), delay + 1);

for i = 1:length(x)
    for j = 0:delay
        if i - j > 0
            X(i, j+1) = x(i - j);
        else
            X(i, j+1) = 0;
        end
    end
end

%% КРОК 3: Навчання мережі
w = zeros(1, delay + 1);   % Початкові ваги
eta = 0.01;                % Швидкість навчання
epochs = 100;              % Кількість епох
error_plot = zeros(1, epochs);  % Для графіка помилки

for epoch = 1:epochs
    mse = 0;
    for i = 1:length(x)
        y = dot(w, X(i, :));
        e = d(i) - y;
        w = w + eta * e * X(i, :);
        mse = mse + e^2;
    end
    error_plot(epoch) = mse / length(x);
end

y_pred = X * w';

%% КРОК 4: Побудова графіка помилки
figure;
plot(1:epochs, error_plot, 'LineWidth', 2);
xlabel('Епоха');
ylabel('Середньоквадратична помилка (MSE)');
title('Динаміка помилки при навчанні');
grid on;

%% КРОК 5: Вивчення впливу кількості блоків затримки
maxDelay = 10;
mse_by_delay = zeros(1, maxDelay + 1);

for dly = 0:maxDelay
    X = zeros(length(x), dly + 1);
    for i = 1:length(x)
        for j = 0:dly
            if i - j > 0
                X(i, j + 1) = x(i - j);
            else
                X(i, j + 1) = 0;
            end
        end
    end

    w = zeros(1, dly + 1);
    for epoch = 1:epochs
        for i = 1:length(x)
            y = dot(w, X(i, :));
            e = d(i) - y;
            w = w + eta * e * X(i, :);
        end
    end

    y_pred = X * w';
    mse_by_delay(dly + 1) = mean((d - y_pred').^2);
end

figure;
plot(0:maxDelay, mse_by_delay, '-o', 'LineWidth', 2);
xlabel('Кількість блоків затримки');
ylabel('MSE');
title('Залежність точності від кількості блоків затримки');
grid on;
