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
