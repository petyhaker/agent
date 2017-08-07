:- consult(read_file).

% here are the "calls" to get the graphs from the stores
% replace these with actual REST calls
getGraph("http://www.amazon.com/api/") :- consult(database/amazonGraph).
getGraph("http://www.foo.com/api/") :- consult(database/fooGraph).
getGraph("http://www.beneton.com/")  :- consult(database/benetonGraph).
getGraph("http://www.skroutz.com/api/") :- consult(database/skroutzGraph).

% explore the availability on all stores
% start_traverse(INTENSION, URLS_LIST, ACCUMULATOR, RESULT)
start_traverse(_, [end_of_file], Result, Result).
start_traverse(Intension, [ A | URLS], Acc, X) :- getGraph(A), write(A), next_state(Intension, entry, A, State),
																									path(Intension, State, Request, Method),
																									agent_inner(Intension, Request, Method, Result, [], State), write(Result),
																									start_traverse(Intension, URLS, [Result|Acc], X).

check_availability([A|URLS], SearchBy, Value) :- searchProduct(A, SearchBy, Value, ProductInfo).


% traverse the graph of 1 store
% agent_inner(INTENSION, REQUEST, METHOD, RESULT, ACCUMULATOR, STATE)

agent_inner(Intension, Request, Method, [ end | Result], Result, _) :-path(Intension, State, Request, Method), next_state(Intension, State, Request,  end), !.
agent_inner(Intension, Request, Method, Result, Acc, State) :- path(Intension, State, Request, Method), status_code(Request,200), write(State),
																															next_state(Intension, State, Request, NextState), path(Intension, NextState, NextRequest, NextMethod),
																															write(NextMethod), agent_inner(Intension, NextRequest, NextMethod, Result, [NextState | Acc], NextState), !.

% starting point
% start(INTENSION, SCOPE, RESULT) - SCOPE says to the agent whether to search all or a specific store
start(buyProduct, all, Result) :- collect_prices(URLS, 'name', 'Moby Dick', [], ProductList), predsort(ProductList, SortedProductList),
 																	con
start(Intension, all, Result) :- input('database/trusted_stores.txt', URLS), write(URLS), start_traverse(Intension, URLS, [], Result).
start(Intension, Store, Result) :- start_traverse(Intension, [Store, end_of_file], [], Result).

% lets assume that the search is being done by the server and I only get the json for specific product

searchProduct("http://www.amazon.com/api/", 'name', 'Moby Dick', "database/amazonDB.json").

% go here id Intension==buyProduct & Scope==all
collect_prices([end_of_file],  _, _, Result, Result).
collect_prices([A|URLS], SearchBy, Value, Acc, Result) :- not(searchProduct(A, SearchBy, Value, ProductInfo)),
																						collect_prices(URLS, SearchBy, Value, Acc, Result).
collect_prices([A|URLS], SearchBy, Value, Acc, Result) :- searchProduct(A, SearchBy, Value, ProductInfo),
																					 open(ProductInfo, read, Str), json_read_dict(Str,Pr), close(Str)
 																					 Pr.offers.avalability == "no",  collect_prices(URLS, SearchBy, Value, Acc, Result).
collect_prices([A|URLS], SearchBy, Value, Acc, Result) :- searchProduct(A, SearchBy, Value, ProductInfo),
																						open(ProductInfo, read, Str), json_read_dict(Str,Pr), close(Str), atom_number(Pr.offers.price, Price),
																						collect_prices(URLS, SearchBy, Value, [[Price, A]|Acc], Result).



compareAvg(X,  [A1, _], [A2, _]) :- compare(X, A1, A2).
