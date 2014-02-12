json_string(A) :- atom(A).
json_number(A) :- integer(A).
json_value(A) :- json_string(A).
json_value(A) :- json_number(A).
json_value(A) :- json_object(A).
json_value(A) :- json_array(A).

json_members([Pair|Members]) :-
    json_pair(Pair),
    ['44'],
    !,
    json_members(Members).

json_members([Pair]) :-
    json_pair(Pair).

json_pair(Pair).

json_pair(String, Value) :- json_pair([String|Value]).


json_pair([String|Value) :- 
    ws,
    json_string(String),
    ws,
    [':'],
    ws,
    json_value(Value),
    ws.

ws :-
    ws_char,
    !,
    ws.
ws :- [].

ws_char :-
    [Char],
    { core:char_type(Char, space) }.




