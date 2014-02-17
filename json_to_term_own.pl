parsed_json(JSONString, Object) :-
	atom_chars(JSONString, Chars),
	phrase(parse_object(Object), Chars).

parse_object(Object) -->
	['{'],
	parse_object_rest(Object).

parse_object_rest(json_object(Members)) -->
	parse_members(Members),
	['}'],
	!.


parse_object_rest(json_object([])) -->
	['}'],
	!.

parse_members([Pair|Members]) -->
	parse_pair(Pair),
	[','],
	parse_members(Members).

parse_members([Pair]) -->
	parse_pair(Pair).

parse_pair(json_pair(Key, Value)) -->
	parse_key(Key),
	[':'],
	parse_value(Value).

parse_key(Key) -->
	parse_string(Key).

parse_value(Value) -->
	parse_string(Value),
	!.	

parse_value(Value) -->
	parse_number(Value),
	!.

parse_value(Value) -->
	parse_object(Value).	

parse_value(Value) -->
	parse_array(Value).

parse_array(Array) -->
	['['],
	parse_array_rest(Array).

parse_array_rest(json_array(Array)) -->
	parse_elements(Array),
	[']'].

parse_array_rest(json_array([])) -->
	[']'].


parse_elements([Value|Elements]) -->
	parse_value(Value),
	[','],
	parse_elements(Elements).

parse_elements([Value]) -->
	parse_value(Value).

parse_number(Number) -->
	[Number],
	{atom_number(Number, Integer)},
	{integer(Integer)}.

parse_string(String) -->
	['"'],
	parse_string_rest(String).

parse_string_rest(String) -->
	[String],
	{atom(String)},
	!,
	parse_string_rest(String).

parse_string_rest(String) -->
	['"'].



