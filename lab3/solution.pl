% Вариант 4
% "Расстановка мебели". Площадь разделена на шесть квадратов, пять из них заняты мебелью, шестой - свободен. Переставить мебель так,
% чтобы шкаф и кресло поменялись местами,  при этом никакие два предмета не могут стоять на одном квадрате.


% Возможные варианты движения ячеек
%Передвижение по горизонтали
location([space, A, B, C, D, E],[A, space, B, C, D, E]).
location([A, space, B, C, D, E],[A, B, space, C, D, E]).
location([A, B, C, space, D, E],[A, B, C, D, space, E]).
location([A, B, C, D, space, E],[A, B, C, D, E, space]).
%Передвижение по вертикали
location([space, A, B, C, D, E],[C, A, B, space, D, E]).
location([A, space, B, C, D, E],[A, D, B, C, space, E]).
location([A, B, space, C, D, E],[A, B, E, C, D, space]).


% Переход из одного состояния в другое
move(X,Y):- location(X,Y); location(Y,X).


% Построение новых путей
new_condition([Current|T], [Next, Current|T]):- move(Current, Next), not(member(Next,[Current|T])).


% Печать в обратном порядке
reverse_print([]).
reverse_print([H|T]):- reverse_print(T),  write(H), nl.


% ПОИСК В ГЛУБИНУ
% Поиск нужной вершины
dfs([Loc2|T], Loc2, [Loc2|T]).
dfs(CurrentWay, Loc2, LastWay):- new_condition(CurrentWay, NextWay), dfs(NextWay, Loc2, LastWay).


% Вывод результата
find_dfs(Loc1, Loc2):- get_time(Time1), dfs([Loc1], Loc2, LastWay), reverse_print(LastWay), get_time(Time2), Time is Time2 - Time1, nl, write('Time of Depth First Searching: '), write(Time), nl.


% ПОИСК В ШИРИНУ
% Поиск нужной вершины
bfs([[Loc2|T]|_], Loc2, [Loc2|T]).
bfs([CurrentWay|QueueWays], Loc2, LastWay):- findall(NextWay, new_condition(CurrentWay, NextWay), List), append(QueueWays,  List, GoodQueue), !, bfs(GoodQueue, Loc2, LastWay).


% Удаление из очереди непродляемого пути
bfs([_|T], Y, List):- bfs(T, Y, List).


% Вывод результата
find_bfs(Loc1, Loc2):- get_time(Time1), bfs([[Loc1]], Loc2, LastWay), reverse_print(LastWay), get_time(Time2), Time is Time2 - Time1, nl, write('Time of Breadth First Searching: '), write(Time), nl.


% ПОИСК С ИТЕРАЦИОННЫМ ЗАГЛУБЛЕНИЕМ
% Погружение
ids([Loc2|T], Loc2, [Loc2|T], 0).
ids(CurrentWay, Loc2, LastWay, L):- L > 0, new_condition(CurrentWay, NextWay), L1 is L - 1, ids(NextWay, Loc2, LastWay, L1).


% Рекурсивная генерация целых чисел
generation(1).
generation(X):- generation(Y), X is Y + 1.


% Поиск путей на разных уровнях
find_ids(Loc1, Loc2, LastWay):- generation(Level), find_ids(Loc1, Loc2, LastWay, Level).


% Вывод результата
find_ids(Loc1, Loc2):- get_time(Time1), generation(Level), ids([Loc1], Loc2, LastWay, Level), reverse_print(LastWay), get_time(Time2), Time is Time2 - Time1, nl, write('Time of Iterative Deepening Searching: '), write(Time), nl.
