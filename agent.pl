:- consult(read_file).

% replace these with actual REST calls
getGraph("http://www.amazon.com/api") :- consult(database/amazonGraph).
getGraph("http://www.foo.com/api") :- consult(database/fooGraph).
getGraph("http://www.beneton.com")  :- consult(database/benetonGraph).
getGraph("http://www.skroutz.com/api") :- consult(database/skroutzGraph).

% explore the availability on all stores
check_availability( [end_of_file], Result, Result).
check_availability( [ A | URLS], Acc, X) :- getGraph(A), string_concat(A, "/search", Request), write(A),
																									agent_inner(Request, get, Result, []),write(Result), check_availability(URLS, [Result|Acc], X).
% traverse the graph of 1 store
agent_inner(Request, _, Result, Result) :- status_code(Request, 400).
agent_inner(Request, _, Result, Result) :- status_code(Request, 500).
agent_inner(Request, _ , [ receipt | Result], Result) :- path(State, Request, _), next_state(State, Request,  receipt), !.
agent_inner(Request, Method, Result, Acc) :-status_code(Request,200),path(State, Request, Method), next_state(State, Request, NextState),
                                          path(NextState, NextRequest, Method), agent_inner(NextRequest, Method, Result, [NextState | Acc]), !.

% starting point
start(Result) :- input('database/trusted_stores.txt', URLS), write(URLS), check_availability(URLS, [], Result).

% intention, scope(all stores or one), query (if it applies)
