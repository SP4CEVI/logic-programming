# Отчет по лабораторной работе №1
## Работа со списками и реляционным представлением данных
## по курсу "Логическое программирование"

### студент: Назаров В.И.

## Результат проверки

| Преподаватель     | Дата         |  Оценка       |
|-------------------|--------------|---------------|
| Сошников Д.В. |              |               |
| Левинская М.А.|              |               |

> *Комментарии проверяющих (обратите внимание, что более подробные комментарии возможны непосредственно в репозитории по тексту программы)*


## Введение
В Прологе списки являются рекурсивными структурами, в отличие от принятых в императивных языках подходов к хранению данных. Работа со списками напоминает работу с очередями. Помимо этого списки в Прологе неизменяемы, значит, что для какого-либо изменения списка, нужно создавать новый список. Но есть и схожие черты. Например, списки в этом языке могут содержать элементы разных типов, как в Python, C++ и др. Также односвязные списки и списки в Прологе похожи тем, что состоят из двух частей: текущий элемент (голова) + ссылка на следующий (хвост).  

## Задание 1.1: Предикат обработки списка

`my_length(List, Size).` - предикат считает длину списка.

Примеры использования:
```prolog
?- my_length([1, 2, 3, 5], X).
X = 4 .

?- my_length([], X).
X = 0 .
```
Реализация:
```prolog
my_length([], 0) .
my_length([_|Y], X) :- my_length(Y, X1), X is X1 + 1.
```

`my_member(X, List).` - предикат проверяет наличие элемента в списке.

Примеры использования:
```prolog
?- my_length([1, 2, 3, 5], X).
X = 4 .

?- my_length([], X).
X = 0 .
```
Реализация:
```prolog
my_member(X,[X|L]).
my_member(X,[L|T]) :- my_member(X,T).
```

`my_append(List1, List2, X).` - предикат объединяет два списка.

Примеры использования:
```prolog
?- my_append([1, 2], [a, b], X).
X = [1, 2, a, b].

?- my_append([1, 2], X, [1, 2, a, b]).
X = [a, b].
```
Реализация:
```prolog
my_append([],L,L).
my_append([X|Y], L, [X|R]) :- my_append(Y,L,R).
```

`my_remove(List, X, Y).` - предикат удаляет элемент из списка.

Примеры использования:
```prolog
?- my_remove([1,2,3,4], 2, X).
X = [1, 3, 4] .

?- my_remove([1,2,3,4], 11, X).
false.

?- my_remove([1,2,3,4], X , [1, 2, 4]).
X = 3.
```
Реализация:
```prolog
my_remove([X|Y], X, Y).
my_remove([Y|Z], X, [Y|R]) :- my_remove(Z, X, R).
```

`my_permute([], []).` - предикат перестановки элементов в списке.

Примеры использования:
```prolog
?- my_permute([1, 2, a], X).
X = [1, 2, a] ;
X = [1, a, 2] ;
X = [2, 1, a] ;
X = [2, a, 1] ;
X = [a, 1, 2] ;
X = [a, 2, 1] ;
false.
```
Реализация:
```prolog
my_permute([], []).
my_permute(L, [X|Y]) :- my_remove(L, X, R), my_permute(R, Y).
```

`my_sublist(X, []).` - предикат подсписка списка.

Примеры использования:
```prolog
?- my_sublist(X, [1, 2, a]).
X = [] ;
X = [1] ;
X = [1, 2] ;
X = [1, 2, a] ;
X = [] ;
X = [2] ;
X = [2, a] ;
X = [] ;
X = [a] ;
X = [] ;
false.
```
Реализация:
```prolog
my_sublist(X, Y) :- my_append(_, X, R), my_append(R, _, Y).
```

Предикат обработки списков: 'last_el(List, R)' - получение последнего элемента списка, используя стандартные предикаты; 'my_last_el(List, X).' - получение последнего элемента списка.

Примеры использования:
```prolog
?- last_el([1, 2, a], X).
X = a .
?- my_last_el([1, 2, a], X).
X = a .
```
Реализация:
```prolog
% используя стандартные предикаты
last_el(X, R) :- append(_, [R], X).

% без использования стандартных предикатов
my_last_el([X], X).
my_last_el([_|Y], X) :- my_last_el(Y, X).
```

'last_el': использует встроенный предикат 'append' для разделения списка на префикс и суффикс.

'my_last_el': использует рекурсию ждя перемещения в конец списка.

## Задание 1.2: Предикат обработки числового списка

Предикат обработки числовых списков: 'scalar_product(List1, List2, R)' - вычисление скалярного произведения двух векторов-списков (с учетом возможного несовпадения размерностей), используя стандартные предикаты; 'my_scalar_product(List1, List2, R)' - вычисление скалярного произведения двух векторов-списков (с учетом возможного несовпадения размерностей).

Примеры использования:
```prolog
?- scalar_product([1, 2], [3, 4], X).
X = 11.

?- scalar_product([1, 2], [3, 4, 5], X).
X = 'Sizes do not match'.

?- my_scalar_product([1, 2], [3, 4], X).
X = 11.

?- my_scalar_product([1, 2], [3, 4, 5], X).
X = 'Sizes do not match'.
```
Реализация:
```prolog
% используя стандартные предикаты
scalar_product(X, Y, R) :- length(X, L1), length(Y, L2), (L1 =:= L2 -> sc_pr(X, Y, R); R = 'Sizes do not match').

sc_pr([], [], 0).
sc_pr([X|X1], [Y|Y1], R) :- sc_pr(X1, Y1, R1), R is X * Y + R1.

% без использования стандартных предикатов
my_scalar_product(X, Y, R) :- (check_length(X, Y) -> my_sc_pr(X, Y, R); R = 'Sizes do not match').

check_length([], []).
check_length([_|Xs], [_|Ys]) :- check_length(Xs, Ys).

my_sc_pr([], [], 0).
my_sc_pr([X|X1], [Y|Y1], R) :- my_sc_pr(X1, Y1, R1), R is X * Y + R1.
```

'scalar_product(List1, List2, R)': используется встроенный предикат 'length', чтобы определить и сравнить длины двух списков. При равенстве вычисляется скалярное произведение, при разных длинах результат равен 'Sizes do not match'. Предикат 'sc_pr' используется для вычисления скалярного произведения двух списков. Он рекурсивно перемножает соответствующие элементы списков и накапливает результат. 

'my_scalar_product(List1, List2, R)': используется предикат 'check_length' для проверки длин списков. При равенстве вычисляется скалярное произведение, при разных длинах результат равен 'Sizes do not match'. Предикат 'check_length' рекурсивно проверяет длины списков, проверяя, что оба списка пусты одновременно. Если списки содержат хотя бы один элемент, то предикат 'check_length' рекурсивно вызывает себя на хвостах списков, продвигаясь по спискам и проверяя их одновременно. Предикат 'my_sc_pr' используется для вычисления скалярного произведения двух списков. Он рекурсивно перемножает соответствующие элементы списков и накапливает результат. 

## Задание 2: Реляционное представление данных

Преимущество реляционного представления заключается в структурированнности, организованности и доступности данных. Но такой способ представления сложен в обработке. В формате представления 'four.pl' достоинством является удобное отношение между данными 'group' и 'subject'.

Примеры использования:
```prolog
?- write_average_marks.
Логическое программирование : 4.107142857142857
Математический анализ : 4.035714285714286
Функциональное программирование : 4.107142857142857
Информатика : 3.8214285714285716
Английский язык : 4
Психология : 3.857142857142857
true.

?- write_failed_group.
102 : 3
101 : 3
104 : 2
103 : 2
true.

?- write_failed_subject.
Логическое программирование : 3
Математический анализ : 1
Функциональное программирование : 0
Информатика : 2
Английский язык : 2
Психология : 2
true.
```
Реализация:
```prolog
% ЗАДАНИЕ 2. РЕЛЯЦИОННОЕ ПРЕДСТАВЛЕНИЕ ПРЕДМЕТНОЙ ОБЛАСТИ
% вариант представления: 4
% вариант задания: 2

:- encoding(utf8).
:-['four.pl'].

% НАПЕЧАТАТЬ СРЕДНИЙ БАЛЛ ДЛЯ КАЖДОГО ПРЕДМЕТА
% Получение списка оценок
get_subject_grades(Subject, Grades) :- subject(Subject, GradesList), findall(Grade, member(grade(_, Grade), GradesList), Grades).

% Подсчёт средних оценок
average_mark_subject(Subject, Average) :- get_subject_grades(Subject, Grades), length(Grades, Count), sum(Grades, Sum), Average is Sum / Count.

% Вывод
write_average_marks :- findall(Subject, subject(Subject, _), Subjects), write_average_marks(Subjects).

write_average_marks([]).
write_average_marks([Subject|Tail]) :- average_mark_subject(Subject, Average), write(Subject), write(' : '), write(Average), nl, write_average_marks(Tail).

sum([], 0).
sum([X|Xs], Sum) :- sum(Xs, Sum1), Sum is X + Sum1.


% ДЛЯ КАЖДОЙ ГРУППЫ, НАЙТИ КОЛИЧЕСТВО НЕСДАВШИХ СТУДЕНТОВ
% Проверка, что у студента неудовлитворительная оценка
failed_grade(Grade) :- Grade < 3.

% Получение списка студентов в группе
get_group_students(Group, Students) :- group(Group, Students).

% Получение оценок студентов для группы и предмета
get_group_grades(Group, Subject, Grades) :- get_group_students(Group, Students), findall(Grade, (member(Student, Students), subject(Subject, Grades), member(grade(Student, Grade), Grades)), Grades).
get_groups(Groups) :- findall(Group, group(Group, _), Groups).

% Подсчет количества не сдавших студентов в группе
count_failed_group(Group, Count) :- get_group_grades(Group, _, Grades), findall(Grade, (member(Grade, Grades), failed_grade(Grade)), FailedGrades), length(FailedGrades, Count).

% Вывод
write_failed_group :- get_groups(Groups), write_failed_group(Groups).

write_failed_group([]).
write_failed_group([Group|Tail]) :- count_failed_group(Group, Count), write(Group), write(' : '), write(Count), nl, write_failed_group(Tail).


% НАЙТИ КОЛИЧЕСТВО НЕ СДАВШИХ СТУДЕНТОВ ДЛЯ КАЖДОГО ИЗ ПРЕДМЕТОВ
% Получение списка оценок
get_all_grades(Subject, Grades) :- subject(Subject, Students), findall(Grade, (member(grade(Student, Grade), Students), Student \= Subject), Grades).

% Получение списка предметов
get_subjects(Subjects) :- findall(Subject, subject(Subject, _), Subjects).

% Подсчет количества не сдавших студентов предмет
count_failed_students(Subject, Count) :- get_all_grades(Subject, Grades), findall(FailedGrade, (member(Grade, Grades), failed_grade(Grade)), FailedGrades), length(FailedGrades, Count).

% Вывод
write_failed_subject :- get_subjects(Subjects), write_failed_subject(Subjects).

write_failed_subject([]).
write_failed_subject([Subject|Tail]) :- count_failed_students(Subject, Count), write(Subject), write(' : '), write(Count), nl, write_failed_subject(Tail).
```


## Выводы
В ходе лабораторной работы я реализовал стандартные предикаты обрабтки списков и понял принцип работы с предикатами в Прологе, также написал предикат для поиска последнего элемента в списке, используя стандартные предикаты, и без их использования. Кроме этого реализовал предикат для обработки числового списка, так же используя и не используя стандартные предикаты. 
Во время лабораторной работы я научился работать с реляционными типами данных (базой данных с оценками студентов). В Прологе интересно устроена работа с обработкой таблиц и отношений, но их довольно сложно обрабатывать по сравнению с императивными языками программирования. Поэтому такие языки, как Пролог, подходят больше для логического программирования и задач с множеством различных условий.
