:- consult(read_file).

:- use_module(library(http/json)).
:- use_module(library(http/json_convert)).

% here are the "calls" to get the graphs from the stores
% replace these with actual REST calls
getGraph("http://www.amazon.com/api/") :- consult(database/amazonGraph).
getGraph("http://www.foo.com/api/") :- consult(database/fooGraph).
getGraph("http://www.beneton.com/")  :- consult(database/benetonGraph).
getGraph("http://www.skroutz.com/api/") :- consult(database/skroutzGraph).

% check if from an entry point there is a valid path to the end point (graph is full and not corrupted)
% traverse_verification(INTENSION, REQUEST, STATE)
traverse_verification(_, _, end).
traverse_verification(Intension, Request, State) :- path(Intension, State, Request, _, _),
																										next_state(Intension, State, Request, NextState),
																										path(Intension, NextState, NextRequest, _, _),
																										traverse_verification(Intension, NextRequest, NextState), !.

% starting point
% agent(INTENSION, SCOPE, SEARCHBY, Value)
agent(Intension, all, SearchBy, Value) :- input('database/trusted_stores.txt', Stores), write(Stores),agent_inner(Intension, Stores, SearchBy, Value, []).
agent(Intension, Scope, SearchBy, Value) :- agent_inner(Intension, Scope, SearchBy, Value, []).

% the starting function "agent" calls this one to filter the stores
% agent_inner(INTENSION, SCOPE, SEARCHBY, Value, ACCUMULATOR)
agent_inner(Intension, [end_of_file], Parameter,  Value, ValidStores) :-  write(Parameter), write(Value), write(ValidStores), traverse(Intension, ValidStores, Parameter, Value). 									% return list of valid stores
agent_inner(Intension, [A|Stores], Parameter, Value, Acc) :- getGraph(A), not( valid_intension(Intension) ),write("am i blue?"),		% if it is not a valid intension for the store exclude it
																														agent_inner(Intension, Stores, Parameter, Value, Acc).
agent_inner(Intension, [A|Stores], Parameter, Value, Acc) :- getGraph(A), valid_intension(Intension), write(A),	 			% if the graph is not traversable exclude it
																															not( traverse_verification(Intension, A, entry) ), write(" not valid graph "),
	      																											agent_inner(Intension, Stores, Parameter, Value, Acc).
agent_inner(Intension, [A|Stores], Parameter, Value, Acc) :- getGraph(A), valid_intension(Intension), write(A),
																														traverse_verification(Intension, A, entry), write("Store OK"), agent_inner(Intension, Stores, Parameter, Value, [A|Acc]).



traverse(buyProduct, Stores, Parameter, Value) :- nl, write(Stores), collect_prices(Stores, Parameter, Value, [], ProductList),write(ProductList), nl,
																									predsort(compareAvg, ProductList, SortedList), write(SortedList).

start() :- input('database/trusted_stores.txt', URLS), write(URLS).


searchProduct("http://www.amazon.com/api/", 'name', 'Moby Dick', "database/amazonDB.json").
% go here if Intension==buyProduct
collect_prices([],  _, _, Result, Result).
collect_prices([A|URLS], SearchBy, Value, Acc, Result) :- not(searchProduct(A, SearchBy, Value, _)), write("over here 1"),
																						collect_prices(URLS, SearchBy, Value, Acc, Result).
collect_prices([A|URLS], SearchBy, Value, Acc, Result) :- searchProduct(A, SearchBy, Value, ProductInfo),write("over here 2"),
																					 open(ProductInfo, read, Str), json_read_dict(Str,Pr), close(Str),
 																					 Pr.offers.availability == "no",  collect_prices(URLS, SearchBy, Value, Acc, Result).
collect_prices([A|URLS], SearchBy, Value, Acc, Result) :- searchProduct(A, SearchBy, Value, ProductInfo), write("over here 3"),
																						open(ProductInfo, read, Str), json_read_dict(Str,Pr), close(Str), atom_number(Pr.offers.price, Price),
																						collect_prices(URLS, SearchBy, Value, [[Price, A]|Acc], Result).

% define a compare function for predsort
compareAvg(X,  [A1, _], [A2, _]) :- compare(X, A1, A2).
