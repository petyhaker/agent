path(buyProduct, basket, "http://www.beneton.com/basket",post, ["usename", "password"]).
path(browseBasket, basket, "http://www.beneton.com/basket",get, ["usename", "password"]).
path(checkoutBasket, basket, "http://www.beneton.com/basket",get, ["usename", "password"]).
path(_ , search, "http://www.beneton.com/search",get, ["name"]).
path(_, product, "http://www.beneton.com/product",get, ["productId"]).
path(_, checkout, "http://www.beneton.com/checkout",get, ["basketId"]).
path(_, payment, "http://www.beneton.com/payment",post, ["creditCard_number", "postage_info"]).
path(_, entry, "http://www.beneton.com/", get, []).
path(_, end, "http://www.beneton.com/", get, []).

% next_state( INTENSION, STATE, SIGNATURE , NEXT_STATE)
next_state(buyProduct, entry,"http://www.beneton.com/", search).
next_state(buyProduct, search,"http://www.beneton.com/search", product).
next_state(buyProduct, product,"http://www.beneton.com/product", basket).
next_state(buyProduct, basket,"http://www.beneton.com/basket", checkout).
next_state(buyProduct, checkout,"http://www.beneton.com/checkout", payment).
next_state(buyProduct, payment,"http://www.beneton.com/payment", end).
next_state(browseProduct, entry,"http://www.beneton.com/", search).
next_state(browseProduct, search,"http://www.beneton.com/search", product).
next_state(browseProduct, product,"http://www.beneton.com/product", end).
next_state(checkoutBasket, entry,"http://www.beneton.com/", basket).
next_state(checkoutBasket, basket,"http://www.beneton.com/basket", checkout).
next_state(checkoutBasket, checkout,"http://www.beneton.com/checkout", payment).
next_state(checkoutBasket, payment,"http://www.beneton.com/payment", end).
next_state(browseBasket, entry,"http://www.beneton.com/", basket).
next_state(browseBasket, basket,"http://www.beneton.com/basket", end).

valid_intension(buyProduct).
valid_intension(browseProduct).
valid_intension(browseBasket).
valid_intension(checkoutBasket).

status_code("http://www.beneton.com/product", 200).
status_code("http://www.beneton.com/basket", 200).
status_code("http://www.beneton.com/checkout", 200).
status_code("http://www.beneton.com/payment", 200).
status_code("http://www.beneton.com/search", 200).
