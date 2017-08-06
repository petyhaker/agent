:- consult(read_file).

%%%%%%%%%%%%%
:- consult(database/amazonGraph_NEW).


% replace these with actual REST calls
getGraph("http://www.amazon.com/api/") :- consult(database/amazonGraph).
getGraph("http://www.foo.com/api/") :- consult(database/fooGraph).
getGraph("http://www.beneton.com/")  :- consult(database/benetonGraph).
getGraph("http://www.skroutz.com/api/") :- consult(database/skroutzGraph).

% explore the availability on all stores
check_availability(_, [end_of_file], Result, Result).
check_availability(Intension, [ A | URLS], Acc, X) :- getGraph(A), write(A), next_state(Intension, entry, A, State),
																									path(Intension, State, Request, Method),
																									agent_inner(Intension, Request, Method, Result, [], State), write(Result),
																									check_availability(Intension, URLS, [Result|Acc], X).

% traverse the graph of 1 store
% agent_inner(NTENSION, REQUEST, METHOD, RESULT, ACCUMULATOR, STATE)
agent_inner(_, Request, _, Result, Result, _) :-  status_code(Request, 400).
agent_inner(_, Request, _, Result, Result, _) :-  status_code(Request, 500).
agent_inner(Intension, Request, Method, [ end | Result], Result, _) :-path(Intension, State, Request, Method), next_state(Intension, State, Request,  end), !.
agent_inner(Intension, Request, Method, Result, Acc, State) :- path(Intension, State, Request, Method), status_code(Request,200), write(State),
																															next_state(Intension, State, Request, NextState), path(Intension, NextState, NextRequest, NextMethod),
																															write(NextMethod), agent_inner(Intension, NextRequest, NextMethod, Result, [NextState | Acc], NextState), !.

% starting point
start(Intension, all, Result) :- input('database/trusted_stores.txt', URLS), write(URLS), check_availability(Intension, URLS, [], Result).
start(Intension, Store, Result) :- check_availability(Intension, [Store, end_of_file], [], Result). 


% intention, scope(all stores or one), query(if it applies)
