% Список форм глаголов
verb('любить', ['любить', 'любит']).
verb('лежать', ['лежать', 'лежат']).
verb('хотеть', ['хочешь', 'хочет']).


% Список вопросов
question('Кто', agent).
question('Кому', agent).
question('Чей', agent).

question('Что', object).
question('Чего', object).
question('Чему', object).

question('Где', location).


% Список слов
slovo('тут', location).
slovo('здесь', location).
slovo('там', location).

slovo('Даша', agent).
slovo('Маша', agent).
slovo('Миша', agent).
slovo('Саша', agent).

slovo('шоколад', object).
slovo('деньги', object).
slovo('клад', object).
slovo('мороженое', object).


% Конкатенация
concat_strings(StringList, StringResult) :- maplist(atom_chars, StringList, CharList), append(CharList, Char), atom_chars(StringResult, Char).


% Поиск формы глагола
find_form(Form, Result) :- verb(Result, Char), member(Form, Char).


% Формирование строки в нужном формате
write_verb(Action, FPred, FArg, SPred, SArg, Result) :- concat_strings([Action, '(', FPred, '(', FArg, '), ', SPred, '(', SArg, ')', ')'], Result).


% Обработка глаголов с подлежащим
verb(agent, SType, S, Action, Result) :- write_verb(Action, agent, 'Y', SType, S, Result).


% Обработка глаголов с объектом
verb(object, SType, S, Action, Result) :- write_verb(Action, SType, S, object, 'Y', Result).


% Обработка глаголов с местоположением
verb(location, SType, S, Action, Result) :- write_verb(Action, SType, S, location, 'Y', Result).


% Обработка входных вопросов
an_q([Question, Action, Subject, '?'], X) :- find_form(Action, NormAction), question(Question, Q), slovo(Subject, SType), verb(Q, SType, Subject, NormAction, X), !.
