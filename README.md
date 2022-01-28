Первое задание. Консольный морской бой
======================================

Задача
------

Создать консольный морской бой на ruby.

Требования
----------

Создаем поле 10х10. Располагаем случайно(!) на нем 4 однопалубных корабля, 3 двухпалубных, 2х3, 4х1. Корабли располагать в соответствии с правилами морского боя - корабли не могут стоять рядом и не могут соприкасаться углами. Морской бой запускать в консоли.

Алгоритм игры
-------------

1. При запуске файла, программа случайно размещает корабли на поле, показывает поле (без кораблей) и предлагает сделать выстрел (смотрим метод gets).
2. Пользователь вводит адрес ячейки на поле (ex: B1, A8). Если пользователь ввел некорректный адрес ячейки, показываем ему сообщение об этом.
3. Отмечаем промах (O) или попадание (X) на поле.
4. Пока все корабли не убиты повторяем шаги 2-3.
5. Выводим “You win!”.
6. Если вместо ячейки ввести “surrender”. Пишем “What a shame…” и показываем расположение всех кораблей на активном поле (с отметками промахов и попаданий). Корабли выводим (S).