:- use_module(library(http/json)).
:- use_module(library(http/json_convert)).

in_json(File, SearchBy, Value, Result) :-
    open(File, read, Str),
    json_read_dict(Str,Result),
    Result.offers.availability =="yes",
    close(Str), nl, !.

compareAvg(X,  [_,A1], [_,A2]) :- compare(X, A1, A2).
