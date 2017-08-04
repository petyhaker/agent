
path(basket, "www.deepgraphs.com/basket",get).
path(basket, "www.deepgraphs.com/basket",post).
path(search, "www.deepgraphs.com/search",get).
path(search, "www.deepgraphs.com/search",post).
path(product, "www.deepgraphs.com/product",get).
path(checkout, "www.deepgraphs.com/checkout",get).
path(payment, "www.deepgraphs.com/payment",get).
path(product, "www.deepgraphs.com/product",get).
path(product, "www.deepgraphs.com/product",get).

next_state(entry,search).
next_state(search, product).
next_state(product, basket).
next_state(basket, checkout).
next_state(checkout, payment).
next_state(payment, receipt).

status_code("www.deepgraphs.com/product", 200).
status_code("www.deepgraphs.com/basket", 200).
status_code("www.deepgraphs.com/checkout", 200).
status_code("www.deepgraphs.com/payment", 200).
status_code("www.deepgraphs.com/search", 200).


affordance_validated(Request, NextState) :-
	status_code(Request,200),
	path(Object, Request, Method),
	% only allowed method withing the list of allowed methods
	member(Method,[get,post]),
	next_state(Object,NextState).

buy(receipt,_ ).

buy(Path, NextState) :-
	path(Path, Request, _),
	affordance_validated(Request, NextState),
	%write(NextState),
	buy(NextState, _), !.
