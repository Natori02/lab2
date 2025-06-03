% Вхідні дані
X = [0 0; 0 1; 1 0; 1 1]';
Y = [0 1 1 0];

% Створення мережі з одним прихованим шаром з 2 нейронами
net = feedforwardnet(2);  % можна змінити кількість нейронів

% Навчання мережі
net = train(net, X, Y);

% Тестування
Y_pred = net(X);
disp('Результати для XOR:');
disp(round(Y_pred));
Результати для XOR:
     1     1     1     1

% Кількість літер
n_letters = 26;

% Імітація вхідних векторів-стовпців довжини 35
% Кожен вектор має випадкове бінарне значення (як приклад)
alphabet = randi([0 1], 35, n_letters);

% Вихідні вектори — one-hot encoding
targets = eye(n_letters);
% Створення мережі
net2 = feedforwardnet(50);  % 50 нейронів у прихованому шарі

% Навчання мережі
net2 = train(net2, alphabet, targets);
% Вибір однієї букви для тестування
test_letter_index = 5;  % наприклад, літера 'E'

% Вхідний вектор
input_vector = alphabet(:, test_letter_index);

% Додавання шуму
noise = randn(35,1) * 0.5;  % шум зі стандартним відхиленням 0.5
noisy_input = input_vector + noise;

% Тестування
output = net2(noisy_input);

% Результат
[~, predicted_letter_index] = max(output);

fprintf('Справжня літера: %d, Розпізнана: %d\n', test_letter_index, predicted_letter_index);
Справжня літера: 5, Розпізнана: 20
% Ініціалізація параметрів
noise_levels = 0:0.05:0.5;  % Стандартні відхилення шуму
n_levels = length(noise_levels);
n_trials = 10;              % Кількість реалізацій для кожного рівня шуму
n_letters = 26;
input_dim = 35;

% Попередня підготовка: створення даних
alphabet = randi([0 1], input_dim, n_letters);
targets = eye(n_letters);

% Навчання мережі
net = feedforwardnet(50);
net = train(net, alphabet, targets);

% Масив для збереження середніх помилок
errors = zeros(1, n_levels);

% Обчислення помилки для кожного рівня шуму
for i = 1:n_levels
    std_dev = noise_levels(i);
    total_error = 0;
    
    for letter_idx = 1:n_letters
        original_vector = alphabet(:, letter_idx);
        target_vector = targets(:, letter_idx);
        
        for trial = 1:n_trials
            % Генерація шуму з середнім 0 та std_dev
            noise = randn(input_dim, 1) * std_dev;
            noisy_input = original_vector + noise;
            
            % Вихід мережі
            output = net(noisy_input);
            
            % Евклідова норма різниці (помилка)
            error = norm(output - target_vector);
            total_error = total_error + error;
        end
    end
    
    % Середня помилка по всіх літерах і спробах
    errors(i) = total_error / (n_letters * n_trials);
end

% Побудова графіка
figure;
plot(noise_levels, errors, '-o', 'LineWidth', 2);
xlabel('Стандартне відхилення шуму');
ylabel('Середня евклідова помилка');
title('Залежність помилки мережі від рівня шуму');
grid on;