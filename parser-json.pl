%parsed_json/2 - true if Object is JSONString 
%parsed in prolgo terms.
parsed_json(JSONString, Object) :-
	atom_chars(JSONString, Chars),
	phrase(parse_object(Object), Chars).

%An object is composed of members 
%within curly braces or just curly braces.
parse_object(json_object(Members)) -->
	whitespace,
	['{'],
	parse_members(Members),
	['}'],
	whitespace,
	!.
parse_object(json_object([]))-->
	whitespace,
	['{'],
	whitespace,
	['}'],
	whitespace,
	!.

%A member is composed of one 
%or more pairs divided by a comma.
parse_members([Pair|MoreMembers]) -->
	parse_pair(Pair),
	[','],
	parse_members(MoreMembers),
	!.
parse_members([Pair]) -->
	parse_pair(Pair),
	!.

%A pair is composed of a string 
%and a value divided by a semicolon.
parse_pair(json_pair(String, Value)) -->
	whitespace,
	parse_string(String),
	whitespace,
	[':'],
	whitespace,
	parse_value(Value),
	whitespace,
	!.

%A value may be a string, 
%a number, an object or an array.
parse_value(Value) -->
	parse_string(Value),
	!.	
parse_value(Value) -->
	parse_number(Value),
	!.
parse_value(Value) -->
	parse_object(Value),
	!.	
parse_value(Value) -->
	parse_array(Value),
	!.

%An array is composed of a list 
%of elements inside square brackets.
parse_array(json_array(Elements)) -->
	['['],
	whitespace,
	parse_elements(Elements),
	whitespace,
	[']'].
parse_array(json_array([])) -->
	['['],
	whitespace,
	[']'].

%Elements are values.
parse_elements([Value|Elements]) -->
	parse_value(Value),
	whitespace,
	[','],
	whitespace,
	parse_elements(Elements).
parse_elements([Value]) -->
	parse_value(Value).

%A number is composed of digits.
parse_number(Digits) -->
	parse_digits_integer(Digits).
parse_number([]).

parse_digits_integer(Integer) -->
	parse_digits(Digits),
	{number_chars(Integer, Digits)}.

%A digit is an integer
parse_digits([Digit|MoreDigits]) -->
	parse_digit(Digit),
	parse_digits(MoreDigits).
parse_digits([Digit]) -->
	parse_digit(Digit).

parse_digit(Digit) -->
	[Digit],
	{atom_number(Digit, Integer)},
	{integer(Integer)}.

%A string is composed of chars.
parse_string(Chars) -->
	['"'],
	parse_chars_atom(Chars),
	['"'].
parse_string([]) -->
	['"'],
	['"'].

%puts the string back together.
parse_chars_atom(Atom) -->
	parse_chars(Chars),
	{atom_chars(Atom,Chars)}.

%A char is an atom.

parse_chars([Char|MoreChars]) -->
	['\\'],
	!,
	parse_quotes(Char),
	parse_chars(MoreChars).
parse_chars([Char|MoreChars]) -->
	parse_char(Char),
	parse_chars(MoreChars).
parse_chars([Char]) -->
	parse_char(Char).

parse_char(Char) -->
	[Char],
	{atom(Char)},
	{not(Char = '"')}.	

parse_quotes(Char) -->
	[Char],
	{atom(Char)},
	{Char = '"'},
	!.

whitespace -->
	ws_char,
	!,
	whitespace.
whitespace -->
	[].

ws_char -->
    [Char],
    {char_type(Char, space)}.

%chain/3 - true if Result can be found
%inside JSON_obj follow the Fields chain.
chain(JSON_obj, Fields, Result) :-
	assert_object(JSON_obj),
	chain_aux(Fields, Result),
	retract_object(JSON_obj),
	!.
chain(JSON_obj, [_], _) :-
	retract_object(JSON_obj),
	false.

chain_aux([Field|Index], Result) :-
	json_pair(Field, json_array(Array)),
	find_index(Index, Array, Result).
chain_aux([Field|[]], Result) :-
	json_pair(Field, Result).

%find_index/3 - recursively find element
%Index in list Array until Result is not an 
%array or there are no more indexes.
find_index([Index|MoreIndexes], Array, Result) :-
	nth0(Index, Array, json_array(New_Array)),
	find_index(MoreIndexes, New_Array, Result).
find_index([Index|[]], Array, Result) :-
	nth0(Index, Array, Result).

%assert_object/1 - asserts a json object.
assert_object(json_object([Member|MoreMembers])) :-
	assert(Member),
	assert_object(json_object(MoreMembers)),
	!.
assert_object(json_object([])).

%retract_object/1 - retracts a json object.
retract_object(json_object([Member|MoreMembers])) :-
	retract(Member),
	retract_object(json_object(MoreMembers)),
	!.
retract_object(json_object([])).
