:- use_module(library(http/json)).
:- use_module(library(http/json_convert)).

:- consult(read_file).

:- input('database/trusted_stores.txt', URLS), write(URLS).

in_json(File, SearchBy, Value, Result) :-
    open(File, read, Str),
    json_read_dict(Str,Result),
    Result.offers.availability =="yes",
    close(Str), nl, !.

compareAvg(X,  [_,A1], [_,A2]) :- compare(X, A1, A2).

path(buyProduct, basket, "http://www.amazon.com/api/basket",post, ["usename", "password"]).

start(Result):- collect_prices(["http://www.amazon.com/api/","http://www.skroutz.com/api/","http://www.foo.com/api/","http://www.beneton.com/",end_of_file], 'name', 'Moby Dick', [], Result).
searchProduct("http://www.amazon.com/api/", 'name', 'Moby Dick', "database/amazonDB.json").
% go here if Intension==buyProduct
collect_prices([end_of_file],  _, _, Result, Result).
collect_prices([A|URLS], SearchBy, Value, Acc, Result) :- not(searchProduct(A, SearchBy, Value, _)),
																						collect_prices(URLS, SearchBy, Value, Acc, Result).
collect_prices([A|URLS], SearchBy, Value, Acc, Result) :- searchProduct(A, SearchBy, Value, ProductInfo),
																					 open(ProductInfo, read, Str), json_read_dict(Str,Pr), close(Str),
 																					 Pr.offers.availability == "no",  collect_prices(URLS, SearchBy, Value, Acc, Result).
collect_prices([A|URLS], SearchBy, Value, Acc, Result) :- searchProduct(A, SearchBy, Value, ProductInfo),
																						open(ProductInfo, read, Str), json_read_dict(Str,Pr), close(Str), atom_number(Pr.offers.price, Price),
																						collect_prices(URLS, SearchBy, Value, [[Price, A]|Acc], Result).
