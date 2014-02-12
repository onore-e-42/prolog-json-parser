parsed_json(JSONString, Object) :-
	string_to_atom(String, JSONString),
	string_to_list(String, [Parenthesis|Tail]),
	Parenthesis == 123,
	last(Tail, Last),
	Last == 125,
	without_last(Tail, ASCII_Members),
	string_to_list(String_Members, ASCII_Members),
	string_to_atom(String_Members, Atom_Members),
	atomic_list_concat(Members, ',', Atom_Members),	
	json_object(Members),
	Object = json_object(Members).

json_object(Members) :-
	json_member(Members).

json_member([]).

json_member([Pair|MoreMembers]) :-
	pair_to_couple(Pair, [String, Value]),
	json_pair(String, Value),
	json_member(MoreMembers).
	
json_pair(String, Value) :-
	json_string(String),
	json_value(Value).
	
json_value(Value) :-
	json_string(Value).

json_string(String) :-
	atom(String).

pair_to_couple(Pair, [String,Value]) :-
	atomic_list_concat([String, Value], ':', Pair).		%:

without_last([_], []).
without_last([X|Xs], [X|WithoutLast]) :- 
    without_last(Xs, WithoutLast).
