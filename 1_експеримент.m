% Вхідні та бажані вихідні значення
x = [5 4 3 2];
d = [10 20 30 40];

% Показуємо навчання з 2 блоками затримки
delay = 2;

% Формування матриці входів
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

% Початкові ваги, швидкість навчання, кількість епох
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

% Виведення результату передбачення
y_pred = X * w';
disp('=== Результат передбачення при 2 блоках затримки ===');
disp(y_pred');

% Дослідження впливу кількості блоків затримки
maxDelay = 10;
mse_list = zeros(1, maxDelay + 1);

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

    % Початкові ваги, параметри
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

    % Передбачення і помилка
    y_pred = X * w';
    mse_list(delay + 1) = mean((d - y_pred').^2);
end

% Побудова графіка залежності MSE від кількості блоків затримки
figure;
plot(0:maxDelay, mse_list, '-o', 'LineWidth', 2);
xlabel('Кількість блоків затримки');
ylabel('Середньоквадратична помилка (MSE)');
title('Вплив кількості блоків затримки на точність');
grid on;
