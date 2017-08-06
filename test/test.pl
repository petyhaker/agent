:- use_module(library(http/json)).
:- use_module(library(http/json_convert)).

in_json(File, Result) :-
    open(File, read, Str),
    json_read(Str,Res),
    write(Res.'Amazon'),
    json_to_prolog(Res, Result),
    close(Str), nl, !.
