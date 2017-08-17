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
agent_inner(Intension, [A|Stores], Parameter, Value, Acc) :- getGraph(A), valid_intension(Intension), 	 			% if the graph is not traversable exclude it
																															not( traverse_verification(Intension, A, entry) ), write(" not valid graph "),
	      																											agent_inner(Intension, Stores, Parameter, Value, Acc).
agent_inner(Intension, [A|Stores], Parameter, Value, Acc) :- getGraph(A), valid_intension(Intension), write(A),
																														traverse_verification(Intension, A, entry), write("Store OK"), agent_inner(Intension, Stores, Parameter, Value, [A|Acc]).


% add productId to search by it (more than 1 product may be available at the same store)
traverse(buyProduct, Stores, Parameter, Value) :- nl, write(Stores), collect_prices(Stores, Parameter, Value, [], []), write("No items match your search").
traverse(browseProduct, Stores, Parameter, Value) :- nl, write(Stores), collect_prices(Stores, Parameter, Value, [], []), write("No items match your search").
traverse(buyProduct, Stores, Parameter, Value) :- nl, write(Stores), collect_prices(Stores, Parameter, Value, [], ProductList),write(ProductList), nl,
																									predsort(compareAvg, ProductList, [[Price, URL, ProductID]|SortedList]),
																									getGraph(URL), path(_, search, Request, _, _),
																									complete_action(buyProduct, search, Request, ProductId).
traverse(browseProduct, Stores, Parameter, Value) :- nl, write(Stores), collect_prices(Stores, Parameter, Value, [], ProductList),write(ProductList), nl,
																									predsort(compareAvg, ProductList, [[Price, URL, ProductID]|SortedList]),
 																								  getGraph(URL), path(_, search, Request, _, _),
																									complete_action(browseProduct, search, Request, ProductId).
traverse(browseBasket, Store, _, Value) :- nl, write("eimai sto traverse in the borowseBasket"), getGraph(Store),path(browseBasket, basket, Request,_, _),
 																								  complete_action(browseBasket, basket, Request, Value).

fix_parameters(["usename", "password"], _).
fix_parameters(["productId"], _).
fix_parameters(["basketId"], _).
fix_parameters(["creditCard_number", "postage_info"],_).
fix_parameters("", _).
http_request("http://www.amazon.com/api/product", _, 200, "foo").
http_request("http://www.amazon.com/api/", _, 200, "").
http_request("http://www.amazon.com/api/basket", _, 200, "verysecurebasketid").
http_request("http://www.amazon.com/api/checkout", _, 200, ["verysecurecardid", ["address foo", 12345]]).
http_request("http://www.amazon.com/api/payment", _, 200, "receiptid").

complete_action(_, end, _, _).
complete_action(Intension, State, Request, Values) :- next_state(Intension, State, Request, NextState), path(Intension, NextState, NextRequest, NextMethod, Parameters),write(Parameters),
																											fix_parameters(Parameters, Values), http_request(NextRequest, NextMethod, Status_Code, Response),write(Response), status_code(Request, Status_Code),
																											write(NextState),write(Values), nl, complete_action(Intension, NextState, NextRequest, Response).




searchProduct("http://www.amazon.com/api/", "name", "Moby Dick", "database/amazonDB.json").
% go here if Intension==buyProduct
collect_prices([],  _, _, Result, Result).
collect_prices([A|URLS], SearchBy, Value, Acc, Result) :- not(searchProduct(A, SearchBy, Value, _)),
																						collect_prices(URLS, SearchBy, Value, Acc, Result).
collect_prices([A|URLS], SearchBy, Value, Acc, Result) :- searchProduct(A, SearchBy, Value, ProductInfo),
																					 open(ProductInfo, read, Str), json_read_dict(Str,Pr), close(Str),
 																					 Pr.offers.availability == "no",  collect_prices(URLS, SearchBy, Value, Acc, Result).
collect_prices([A|URLS], SearchBy, Value, Acc, Result) :- searchProduct(A, SearchBy, Value, ProductInfo),
																						open(ProductInfo, read, Str), json_read_dict(Str,Pr), close(Str), atom_number(Pr.offers.price, Price), ProductId = Pr.productId,
																						collect_prices(URLS, SearchBy, Value, [[Price, A, ProductId ]|Acc], Result).

% define a compare function for predsort
compareAvg(X,  [A1, _], [A2, _]) :- compare(X, A1, A2).
