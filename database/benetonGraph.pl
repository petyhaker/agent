path(buyProduct, basket, "http://www.beneton.com/basket",post).
path(browseBasket, basket, "http://www.beneton.com/basket",get).
path(checkoutBasket, basket, "http://www.beneton.com/basket",get).
path(_ , search, "http://www.beneton.com/search",get).
path(_, product, "http://www.beneton.com/product",get).
path(_, checkout, "http://www.beneton.com/checkout",get).
path(_, payment, "http://www.beneton.com/payment",post).

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


status_code("http://www.beneton.com/product", 200).
status_code("http://www.beneton.com/basket", 200).
status_code("http://www.beneton.com/checkout", 200).
status_code("http://www.beneton.com/payment", 200).
status_code("http://www.beneton.com/search", 200).
