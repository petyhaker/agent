path(basket, "http://www.amazon.com/api/basket",get).
path(basket, "http://www.amazon.com/api/basket",post).
path(search, "http://www.amazon.com/api/search",get).
path(search, "http://www.amazon.com/api/search",post).
path(product, "http://www.amazon.com/api/product",get).
path(checkout, "http://www.amazon.com/api/checkout",get).
path(payment, "http://www.amazon.com/api/payment",get).
path(product, "http://www.amazon.com/api/product",get).
path(product, "http://www.amazon.com/api/product",get).
path(basket, "http://www.beneton.com/basket",get).
path(basket, "http://www.beneton.com/basket",post).
path(search, "http://www.beneton.com/search",get).
path(search, "http://www.beneton.com/search",post).
path(product, "http://www.beneton.com/product",get).
path(checkout, "http://www.beneton.com/checkout",get).
path(payment, "http://www.beneton.com/payment",get).
path(product, "http://www.beneton.com/product",get).
path(product, "http://www.beneton.com/product",get).

next_state(entry," ", search).
next_state(search,"http://www.amazon.com/api/search", product).
next_state(product,"http://www.amazon.com/api/product", basket).
next_state(basket,"http://www.amazon.com/api/basket", checkout).
next_state(checkout,"http://www.amazon.com/api/checkout", payment).
next_state(payment,"http://www.amazon.com/api/payment", receipt).
next_state(search,"http://www.beneton.com/search", product).
next_state(product,"http://www.beneton.com/product",  basket).
next_state(basket, "http://www.beneton.com/basket", checkout).
next_state(checkout,"http://www.beneton.com/checkout", payment).
next_state(payment,"http://www.beneton.com/payment", receipt).

status_code("http://www.amazon.com/api/product", 200).
status_code("http://www.amazon.com/api/basket", 200).
status_code("http://www.amazon.com/api/checkout", 200).
status_code("http://www.amazon.com/api/payment", 200).
status_code("http://www.amazon.com/api/search", 200).
status_code("http://www.beneton.com/product", 200).
status_code("http://www.beneton.com/basket", 200).
status_code("http://www.beneton.com/checkout", 200).
status_code("http://www.beneton.com/payment", 200).
status_code("http://www.beneton.com/search", 200).

agent_inner(Request, _ , [ receipt | Result], Result) :- path(State, Request, _), next_state(State, Request,  receipt), !.
agent_inner(Request, Method, Result, Acc) :-status_code(Request,200),path(State, Request, Method), next_state(State, Request, NextState),
                              path(NextState, NextRequest, Method), agent_inner(NextRequest, Method, Result, [NextState | Acc]), !.
