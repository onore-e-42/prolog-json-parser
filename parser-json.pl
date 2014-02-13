parsed_json(JSONString, json_object(Members)) :-
	json_parser(JSONString, Parsed_String),
	json_analyzer(Parsed_String, Members).

json_parser(JSONString, Members) :-
	string_to_atom(String, JSONString),
	string_to_list(String, [Parenthesis|Tail]),
	Parenthesis == 123,
	last(Tail, Last),
	Last == 125,
	without_last(Tail, ASCII_Members),
	string_to_list(String_Members, ASCII_Members),
	string_to_atom(String_Members, Atom_Members),
	atomic_list_concat(Members, ',', Atom_Members).	
%	json_members(Members, Parsed_Members).

json_analyzer([], []).

json_analyzer([Pair|Members], [Json_Pair|Json_Members]) :-
%	pair_to_couple(Pair, [String, Value]),
%	json_pair(String, Value),
%	string_to_atom(Atom, String),
%	string_to_atom(ValueAtom, Value),
%	Json_Pair = json_pair(Atom, ValueAtom),
	pair_analyzer(Pair, Json_Pair),
	json_analyzer(Members, Json_Members).
	
pair_analyzer(Pair, Analyzed_Pair):-
	pair_to_couple(Pair, [String, Value]),
	value_analyzer(Value, Analyzed_Value),
%	string_to_atom(Atom, String),
%	string_to_atom(ValueAtom, Value),
	Analyzed_Pair = json_pair(Term, Analyzed_Value).

is_string(String):-
	atom(String).

is_string(String):-
	string(String).

%json_pair(String, Value) :-
%	json_string(String),
%	json_value(Value).

	
value_analyzer(Value, Analyzed_Value) :-
	is_string(Value),
	!,
	string_to_atom(Value, Atom),
	term_to_atom(Term, Atom),	
	Analyzed_Value = Term. %togliere "?

value_analyzer(Value, Analyzed_Value) :-
	is_number(Value),
	!,
	Analyzed_Value = Value.

value_analyzer(Value, Analyzed_Value) :-
	string_to_atom(String, Value),
	string_to_list(String, [First|Rest]),
	First==91,
	last(Rest, Last),
	Last==93,
	!,
	term_to_atom(Array, Value),
	Analyzed_Value = json_array(Array).

is_array(Array):-
	value_analyzer(Value, _).	



%json_value(Valu\e) :-
%	json_object(Value).

json_value(Value) :-
	json_array(Value).

is_number(Value) :-
	integer(Value).	



pair_to_couple(Pair, [String,Value]) :-
	atomic_list_concat([String, Value], ':', Pair).

without_last([_], []).
without_last([X|Xs], [X|WithoutLast]) :- 
    without_last(Xs, WithoutLast).
