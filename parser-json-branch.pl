parsed_json(JSONString, Object) :-
string_to_atom(String, JSONString),
string_to_list(String, Members),
Object = json_object(Members).


json_object([Parenthesis|Members]) :-
	Parenthesis == '123',		%{
	last(Members) == '125',		%}
	without_last(Members, Trimmed_Members),
	json_member(Trimmed_Members).

json_member([]).

json_member([Pair|[]]) :-
	pair_to_couple(Pair, [String,Value]),		%controllare se fattibile
	json_pair(String, Value).

json_member(Members) :-
	atom(Members),
	!,
	atomic_list_concat(Pair|MoreMembers], '44', Members),	%,
	pair_to_couple(Pair, [String,Value]),
	json_pair(String, Value),
	json_member(MoreMembers).
	

json_member([Pair|MoreMembers]) :-
	pair_to_couple(Pair, [String,Value]),	
	json_pair(String, Value),
	json_member(MoreMembers).
				
json_pair(String, Value) :-
	json_string(String),
	json_value(Value).
	
json_value(Value) :-
	json_string(Value).

json_value(Value) :-
	json_object(Value).
	
json_value(Value) :-
	json_number(Value).

json_value(Value) :-
	json_array(Value).


json_string(String) :-
	atom(String).

json_number(Number) :-
	integer(Number).

json_array(Array) :-
	json_elements(Array).

json_elements([]).
json_elements([Elements|MoreElements]) :-
	json_value(Elements),
	json_elements(MoreElements).
	
	
	

pair_to_couple(Pair, [String,Value]) :-
	atomic_list_concat([String|Value], '58', Pair).			%:
	
	

without_last([_], []).
without_last([X|Xs], [X|WithoutLast]) :- 
    without_last(Xs, WithoutLast).
