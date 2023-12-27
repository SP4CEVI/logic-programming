#№ Отчет по лабораторной работе №3
## по курсу "Логическое программирование"

## Решение задач методом поиска в пространстве состояний

### студент: Назаров В. И.

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|              |               |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*


## Введение

Метод поиска в пространстве состояний удобен для решения задач, связанных с поиском оптимального пути или состояния в пространстве. Например, для планирования движения беспилотных транспортных средств с использованием ИИ, роботов, поиска оптимальных маршрутов на картах, решения логических задач и др.

Prolog оказывается удобным языком для решения таких задач, т.к. он основан на логике предикатов, это делает его удобным при формулировке и решении логических задач. Также у Prolog есть возможность работать с рекурсией для обхода деревьев поиска и перебором всех возможных вариантов состояний.

## Задание (Вариант 4)

"Расстановка мебели". Площадь разделена на шесть квадратов, пять из них заняты мебелью, шестой - свободен. Переставить мебель так, чтобы шкаф и кресло поменялись местами, при этом никакие два предмета не могут стоять на одном квадрате.
| стол |  стул  |  шкаф  |
|------|--------|----------|
| стул |        |  кресло  |

## Принцип решения

Для начала определим вершину графа - все расположение мебели. После этого запишем все возможные перемещения мебели `location(X, Y)`. Создадим предикат, который будет "двигать" мебель - `move(X, Y)`. Кроме этого потребуюется предикат `new_condition` для построения новых путей, добавляя новые состояния только в том случае, если они удовлетворяют условиям перехода и не были посещены ранее. И нужен предикат для написания всего пути `reverse_print`.

```
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
```

Теперь напишем предикаты для поиска в глубину, начнем с поиска в глубину. Поиск в глубину (DFS) начинается с начального состояния и происходит путем рекурсивного расширения пути в глубину до тех пор, пока возможно продолжение и не будет достигнуто целевое состояние. По достижении целевого состояния, запускается процесс обратного перемещения от цели к начальному состоянию. В результате, получается путь в обратном порядке, который не является необязательно кратчайшим. И как раз используем предикат `reverse_print`, чтобы показать найденный путь в правильном порядке. Кроме того, для измерения времени выполнения используется встроенный предикат `get_time`.

```
% ПОИСК В ГЛУБИНУ
% Поиск нужной вершины
dfs([Loc2|T], Loc2, [Loc2|T]).
dfs(CurrentWay, Loc2, LastWay):- new_condition(CurrentWay, NextWay), dfs(NextWay, Loc2, LastWay).

% Вывод результата
find_dfs(Loc1, Loc2):- get_time(Time1), dfs([Loc1], Loc2, LastWay), reverse_print(LastWay), get_time(Time2), Time is Time2 - Time1, nl, write('Time of Depth First Searching: '), write(Time), nl.
```

Теперь поиск в глубину. Поиск в ширину (BFS) представляет собой метод последовательного обхода элементов, основанный на принципе "первым пришел - первым ушел". Алгоритм начинается с начального состояния и использует очередь для хранения путей, которые могут быть продлены. При расширении пути, новые пути добавляются в конец очереди, а путь, который был продлен, удаляется. Если первый путь в очереди ведет к целевому состоянию, поиск может быть завершен. Найденный путь гарантированно будет кратчайшим, так как все пути расширяются на одну и ту же глубину.

```
% ПОИСК В ШИРИНУ
% Поиск нужной вершины
bfs([[Loc2|T]|_], Loc2, [Loc2|T]).
bfs([CurrentWay|QueueWays], Loc2, LastWay):- findall(NextWay, new_condition(CurrentWay, NextWay), List), append(QueueWays,  List, GoodQueue), !, bfs(GoodQueue, Loc2, LastWay).

% Удаление из очереди непродляемого пути
bfs([_|T], Y, List):- bfs(T, Y, List).

% Вывод результата
find_bfs(Loc1, Loc2):- get_time(Time1), bfs([[Loc1]], Loc2, LastWay), reverse_print(LastWay), get_time(Time2), Time is Time2 - Time1, nl, write('Time of Breadth First Searching: '), write(Time), nl.
```

Для поиска с итеративным заглублением потребуется дополнительный предикат `generation`, который будет генерировать последовательность целых чисел. Он используется для создания последовательных номеров шагов в алгоритме.

Метод итерационного поиска включает в себя комбинацию поиска в глубину и поиска в ширину. Он осуществляет поиск в глубину до достижения определенного уровня "погружения", который увеличивается с каждой итерацией. Для каждого уровня "погружения" используется предикат `generation`. Начиная с уровня погружения 1, поиск происходит, как в алгоритме поиска в глубину, при этом сохраняются все положительные аспекты этого алгоритма. Ограничение на длину пути позволяет найти кратчайший путь, и отсутствие требования к затратам памяти делает его эффективным.

```
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
```

## Результаты

**Поиск в глубину**

К сожалению, в моем терминале не получается увидеть полную длину, но ниже приведена часть всех путей, не с самого начала. Но можно сказать, что шагов >180.

```
?- find_dfs([table, chair, wardrobe, chair, space, armchair], [table, chair, armchair, chair, space, wardrobe]).
...........................................
[chair,space,wardrobe,chair,armchair,table]
[chair,wardrobe,space,chair,armchair,table]
[chair,wardrobe,table,chair,armchair,space]
[chair,wardrobe,table,chair,space,armchair]
[chair,wardrobe,table,space,chair,armchair]
[space,wardrobe,table,chair,chair,armchair]
[wardrobe,space,table,chair,chair,armchair]
[wardrobe,table,space,chair,chair,armchair]
[wardrobe,table,armchair,chair,chair,space]
[wardrobe,table,armchair,chair,space,chair]
[wardrobe,table,armchair,space,chair,chair]
[space,table,armchair,wardrobe,chair,chair]
[table,space,armchair,wardrobe,chair,chair]
[table,armchair,space,wardrobe,chair,chair]
[table,armchair,chair,wardrobe,chair,space]
[table,armchair,chair,wardrobe,space,chair]
[table,armchair,chair,space,wardrobe,chair]
[space,armchair,chair,table,wardrobe,chair]
[armchair,space,chair,table,wardrobe,chair]
[armchair,chair,space,table,wardrobe,chair]
[armchair,chair,chair,table,wardrobe,space]
[armchair,chair,chair,table,space,wardrobe]
[armchair,space,chair,table,chair,wardrobe]
[armchair,chair,space,table,chair,wardrobe]
[armchair,chair,wardrobe,table,chair,space]
[armchair,chair,wardrobe,table,space,chair]
[armchair,chair,wardrobe,space,table,chair]
[space,chair,wardrobe,armchair,table,chair]
[chair,space,wardrobe,armchair,table,chair]
[chair,wardrobe,space,armchair,table,chair]
[chair,wardrobe,chair,armchair,table,space]
[chair,wardrobe,chair,armchair,space,table]
[chair,wardrobe,chair,space,armchair,table]
[space,wardrobe,chair,chair,armchair,table]
[wardrobe,space,chair,chair,armchair,table]
[wardrobe,chair,space,chair,armchair,table]
[wardrobe,chair,table,chair,armchair,space]
[wardrobe,chair,table,chair,space,armchair]
[wardrobe,chair,table,space,chair,armchair]
[space,chair,table,wardrobe,chair,armchair]
[chair,space,table,wardrobe,chair,armchair]
[chair,table,space,wardrobe,chair,armchair]
[chair,table,armchair,wardrobe,chair,space]
[chair,table,armchair,wardrobe,space,chair]
[chair,space,armchair,wardrobe,table,chair]
[chair,armchair,space,wardrobe,table,chair]
[chair,armchair,chair,wardrobe,table,space]
[chair,armchair,chair,wardrobe,space,table]
[chair,armchair,chair,space,wardrobe,table]
[space,armchair,chair,chair,wardrobe,table]
[armchair,space,chair,chair,wardrobe,table]
[armchair,chair,space,chair,wardrobe,table]
[armchair,chair,table,chair,wardrobe,space]
[armchair,chair,table,chair,space,wardrobe]
[armchair,chair,table,space,chair,wardrobe]
[space,chair,table,armchair,chair,wardrobe]
[chair,space,table,armchair,chair,wardrobe]
[chair,table,space,armchair,chair,wardrobe]
[chair,table,wardrobe,armchair,chair,space]
[chair,table,wardrobe,armchair,space,chair]
[chair,table,wardrobe,space,armchair,chair]
[space,table,wardrobe,chair,armchair,chair]
[table,space,wardrobe,chair,armchair,chair]
[table,wardrobe,space,chair,armchair,chair]
[table,wardrobe,chair,chair,armchair,space]
[table,wardrobe,chair,chair,space,armchair]
[table,wardrobe,chair,space,chair,armchair]
[space,wardrobe,chair,table,chair,armchair]
[wardrobe,space,chair,table,chair,armchair]
[wardrobe,chair,space,table,chair,armchair]
[wardrobe,chair,armchair,table,chair,space]
[wardrobe,chair,armchair,table,space,chair]
[wardrobe,space,armchair,table,chair,chair]
[wardrobe,armchair,space,table,chair,chair]
[wardrobe,armchair,chair,table,chair,space]
[wardrobe,armchair,chair,table,space,chair]
[wardrobe,armchair,chair,space,table,chair]
[space,armchair,chair,wardrobe,table,chair]
[armchair,space,chair,wardrobe,table,chair]
[armchair,table,chair,wardrobe,space,chair]
[armchair,table,chair,wardrobe,chair,space]
[armchair,table,space,wardrobe,chair,chair]
[armchair,space,table,wardrobe,chair,chair]
[space,armchair,table,wardrobe,chair,chair]
[wardrobe,armchair,table,space,chair,chair]
[wardrobe,armchair,table,chair,space,chair]
[wardrobe,armchair,table,chair,chair,space]
[wardrobe,armchair,space,chair,chair,table]
[wardrobe,space,armchair,chair,chair,table]
[wardrobe,chair,armchair,chair,space,table]
[wardrobe,chair,armchair,chair,table,space]
[wardrobe,chair,space,chair,table,armchair]
[wardrobe,space,chair,chair,table,armchair]
[wardrobe,table,chair,chair,space,armchair]
[wardrobe,table,chair,chair,armchair,space]
[wardrobe,table,space,chair,armchair,chair]
[wardrobe,space,table,chair,armchair,chair]
[space,wardrobe,table,chair,armchair,chair]
[chair,wardrobe,table,space,armchair,chair]
[chair,wardrobe,table,armchair,space,chair]
[chair,wardrobe,table,armchair,chair,space]
[chair,wardrobe,space,armchair,chair,table]
[chair,space,wardrobe,armchair,chair,table]
[space,chair,wardrobe,armchair,chair,table]
[armchair,chair,wardrobe,space,chair,table]
[armchair,chair,wardrobe,chair,space,table]
[armchair,chair,wardrobe,chair,table,space]
[armchair,chair,space,chair,table,wardrobe]
[armchair,space,chair,chair,table,wardrobe]
[armchair,table,chair,chair,space,wardrobe]
[armchair,table,chair,chair,wardrobe,space]
[armchair,table,space,chair,wardrobe,chair]
[armchair,space,table,chair,wardrobe,chair]
[armchair,wardrobe,table,chair,space,chair]
[armchair,wardrobe,table,chair,chair,space]
[armchair,wardrobe,space,chair,chair,table]
[armchair,space,wardrobe,chair,chair,table]
[space,armchair,wardrobe,chair,chair,table]
[chair,armchair,wardrobe,space,chair,table]
[chair,armchair,wardrobe,chair,space,table]
[chair,armchair,wardrobe,chair,table,space]
[chair,armchair,space,chair,table,wardrobe]
[chair,space,armchair,chair,table,wardrobe]
[chair,table,armchair,chair,space,wardrobe]
[chair,table,armchair,chair,wardrobe,space]
[chair,table,space,chair,wardrobe,armchair]
[chair,space,table,chair,wardrobe,armchair]
[space,chair,table,chair,wardrobe,armchair]
[chair,chair,table,space,wardrobe,armchair]
[chair,chair,table,wardrobe,space,armchair]
[chair,chair,table,wardrobe,armchair,space]
[chair,chair,space,wardrobe,armchair,table]
[chair,space,chair,wardrobe,armchair,table]
[space,chair,chair,wardrobe,armchair,table]
[wardrobe,chair,chair,space,armchair,table]
[wardrobe,chair,chair,armchair,space,table]
[wardrobe,chair,chair,armchair,table,space]
[wardrobe,chair,space,armchair,table,chair]
[wardrobe,space,chair,armchair,table,chair]
[wardrobe,table,chair,armchair,space,chair]
[wardrobe,table,chair,armchair,chair,space]
[wardrobe,table,space,armchair,chair,chair]
[wardrobe,space,table,armchair,chair,chair]
[wardrobe,chair,table,armchair,space,chair]
[wardrobe,chair,table,armchair,chair,space]
[wardrobe,chair,space,armchair,chair,table]
[wardrobe,space,chair,armchair,chair,table]
[space,wardrobe,chair,armchair,chair,table]
[armchair,wardrobe,chair,space,chair,table]
[armchair,wardrobe,chair,chair,space,table]
[armchair,wardrobe,chair,chair,table,space]
[armchair,wardrobe,space,chair,table,chair]
[armchair,space,wardrobe,chair,table,chair]
[armchair,table,wardrobe,chair,space,chair]
[armchair,table,wardrobe,space,chair,chair]
[space,table,wardrobe,armchair,chair,chair]
[table,space,wardrobe,armchair,chair,chair]
[table,wardrobe,space,armchair,chair,chair]
[table,wardrobe,chair,armchair,chair,space]
[table,wardrobe,chair,armchair,space,chair]
[table,wardrobe,chair,space,armchair,chair]
[space,wardrobe,chair,table,armchair,chair]
[wardrobe,space,chair,table,armchair,chair]
[wardrobe,chair,space,table,armchair,chair]
[wardrobe,chair,chair,table,armchair,space]
[wardrobe,chair,chair,table,space,armchair]
[wardrobe,chair,chair,space,table,armchair]
[space,chair,chair,wardrobe,table,armchair]
[chair,space,chair,wardrobe,table,armchair]
[chair,chair,space,wardrobe,table,armchair]
[chair,chair,armchair,wardrobe,table,space]
[chair,chair,armchair,wardrobe,space,table]
[chair,space,armchair,wardrobe,chair,table]
[chair,armchair,space,wardrobe,chair,table]
[chair,armchair,table,wardrobe,chair,space]
[chair,armchair,table,wardrobe,space,chair]
[chair,space,table,wardrobe,armchair,chair]
[chair,table,space,wardrobe,armchair,chair]
[chair,table,chair,wardrobe,armchair,space]
[chair,table,chair,wardrobe,space,armchair]
[chair,table,chair,space,wardrobe,armchair]
[space,table,chair,chair,wardrobe,armchair]
[table,space,chair,chair,wardrobe,armchair]
[table,chair,space,chair,wardrobe,armchair]
[table,chair,armchair,chair,wardrobe,space]
[table,chair,armchair,chair,space,wardrobe]

Time of Depth First Searching: 1.9615299701690674
true .
```
**Поиск в ширину**

В результате получается 19 шагов.
```
?- find_bfs([table, chair, wardrobe, chair, space, armchair], [table, chair, armchair, chair, space, wardrobe]).
[table,chair,wardrobe,chair,space,armchair]
[table,chair,wardrobe,chair,armchair,space]
[table,chair,space,chair,armchair,wardrobe]
[table,space,chair,chair,armchair,wardrobe]
[table,armchair,chair,chair,space,wardrobe]
[table,armchair,chair,space,chair,wardrobe]
[space,armchair,chair,table,chair,wardrobe]
[armchair,space,chair,table,chair,wardrobe]
[armchair,chair,space,table,chair,wardrobe]
[armchair,chair,wardrobe,table,chair,space]
[armchair,chair,wardrobe,table,space,chair]
[armchair,space,wardrobe,table,chair,chair]
[space,armchair,wardrobe,table,chair,chair]
[table,armchair,wardrobe,space,chair,chair]
[table,armchair,wardrobe,chair,space,chair]
[table,armchair,wardrobe,chair,chair,space]
[table,armchair,space,chair,chair,wardrobe]
[table,space,armchair,chair,chair,wardrobe]
[table,chair,armchair,chair,space,wardrobe]

Time of Breadth First Searching: 0.09363889694213867
true .
```

**Поиск с итеративным заглублением**

В результате получается так же 19 шагов.
```
?- find_ids([table, chair, wardrobe, chair, space, armchair], [table, chair, armchair, chair, space, wardrobe]).
[table,chair,wardrobe,chair,space,armchair]
[table,chair,wardrobe,chair,armchair,space]
[table,chair,space,chair,armchair,wardrobe]
[table,space,chair,chair,armchair,wardrobe]
[table,armchair,chair,chair,space,wardrobe]
[table,armchair,chair,space,chair,wardrobe]
[space,armchair,chair,table,chair,wardrobe]
[armchair,space,chair,table,chair,wardrobe]
[armchair,chair,space,table,chair,wardrobe]
[armchair,chair,wardrobe,table,chair,space]
[armchair,chair,wardrobe,table,space,chair]
[armchair,space,wardrobe,table,chair,chair]
[space,armchair,wardrobe,table,chair,chair]
[table,armchair,wardrobe,space,chair,chair]
[table,armchair,wardrobe,chair,space,chair]
[table,armchair,wardrobe,chair,chair,space]
[table,armchair,space,chair,chair,wardrobe]
[table,space,armchair,chair,chair,wardrobe]
[table,chair,armchair,chair,space,wardrobe]

Time of Iterative Deepening Searching: 0.06628990173339844
true .
```

| Алгоритм поиска |  Длина найденного первым пути  |  Время работы  |
|-----------------|--------------------------------|----------------|
| В глубину       |             >180               | 1.9615299701690674  |
| В ширину        |              19                | 0.09363889694213867 |
| ID              |              19                | 0.06628990173339844 |

Самый быстрый способ - поиск с итеративным заглублением, его длина 19 шагов. СТолько же шагов у поиска в ширину, но он чуть медленнее. Самым неэффективным получился поиск в глубину, т.к. он занимает больше времени работы и выполняет большое количество шагов. Все они безопасны.

## Выводы

В ходе лабораторной работы я изучил методы поиска в пространстве состояний, изучил основные стратегии решения задач искусственного интеллекта. Написал предикаты для поиска в глубину, ширину и глубину с итеративным заглублением, проанализировал их и оценил.

Я считаю, что поиск с итеративным углублением является наиболее оптимальным для решения этой задачи, потому что он находит кратчайший путь, что нельзя сказать о поиске в глубину, и не требует большого объема используемой памяти, в отличие от поиска в ширину.

Но каждый из этих алгоритмов решили задачу. Хоть поиск в глубину и работает через большое количество шагов и работает дольше, он реализуется легче других, т.к. он является естественным для Prolog.

Поиск в ширину является более сложным в программировании по сравнению с поиском в глубину. Это связано с тем, что в поиске в ширину нам нужно сохранять все альтернативные вершины-кандидаты, а не только одну вершину, как в поиске в глубину. Но в этой задаче он быстро справился с нахождением кратчайшего пути.
