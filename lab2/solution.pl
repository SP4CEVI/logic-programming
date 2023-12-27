all_different([]).
all_different([H|T]) :- not(member(H, T)), all_different(T).

professions([stolyar, malyar, vodoprovodchik]).

solve(K, D, F) :-

    professions([K, D, F]),

    % Каждый из них имеет различную профессию
    all_different([K, D, F]),

    % Один из них столяр, другой маляр, третий водопроводчик
    (K = stolyar; K = malyar; K = vodoprovodchik),
    (D = stolyar; D = malyar; D = vodoprovodchik),
    (F = stolyar; F = malyar; F = vodoprovodchik),

    % Маляр слышал про водопроводчика от столяра
    not((K = malyar, F = vodoprovodchik)),

    % Федоров никогда не слышал о Давыдове
    not(F = D).


