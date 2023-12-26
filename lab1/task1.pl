% РЕАЛИЗАЦИЯ СТАНДАРТНЫХ ПРЕДИКАТОВ

% длина спсика
my_length([], 0) .
my_length([_|Y], X) :- my_length(Y, X1), X is X1 + 1.

% наличие элемента в списке
my_member(X,[X|L]).
my_member(X,[L|T]) :- my_member(X,T).

% конкатенация
my_append([],L,L).
my_append([X|Y], L, [X|R]) :- my_append(Y,L,R).

% удаление элементов из списка
my_remove([X|Y], X, Y).
my_remove([Y|Z], X, [Y|R]) :- my_remove(Z, X, R).

% перестановка элементов списка
my_permute([], []).
my_permute(L, [X|Y]) :- my_remove(L, X, R), my_permute(R, Y).

% подсписок списка
my_sublist(X, Y) :- my_append(_, X, R), my_append(R, _, Y).



% ПРЕДИКАТЫ ОБРАБОТКИ СПИСКОВ (ПОЛУЧЕНИЕ ПОСЛЕДНЕГО ЭЛЕМЕНТА)

% используя стандартные предикаты
last_el(X, R) :- append(_, [R], X).

% без использования стандартных предикатов
my_last_el([X], X).
my_last_el([_|Y], X) :- my_last_el(Y, X).



% ПРЕДИКАТЫ ОБРАБОТКИ ЧИСЛОВЫХ СПИСКОВ (ВЫЧИСЛЕНИЕ СКАЛЯРНОГО ПРОИЗВЕДЕНИЯ ДВУХ ВЕКТОРОВ-СПИСКОВ(С УЧЕТОМ ВОЗМОЖНОГО НЕСОВПАДЕНИЯ РАЗМЕРНОСТЕЙ))

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
