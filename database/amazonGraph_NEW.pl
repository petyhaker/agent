path(buyProduct, basket, "http://www.amazon.com/api/basket",post).
path(browseBasket, basket, "http://www.amazon.com/api/basket",get).
path(_ , search, "http://www.amazon.com/api/search",get).
path(_, product, "http://www.amazon.com/api/product",get).
path(_, checkout, "http://www.amazon.com/api/checkout",get).
path(_, payment, "http://www.amazon.com/api/payment",post).

% next_state( INTENSION, STATE, SIGNATURE , NEXT_STATE)
next_state(buyProduct, entry,"http://www.amazon.com/api/", search).
next_state(buyProduct, search,"http://www.amazon.com/api/search", product).
next_state(buyProduct, product,"http://www.amazon.com/api/product", basket).
next_state(buyProduct, basket,"http://www.amazon.com/api/basket", checkout).
next_state(buyProduct, checkout,"http://www.amazon.com/api/checkout", payment).
next_state(buyProduct, payment,"http://www.amazon.com/api/payment", end).
next_state(browseProduct, entry,"http://www.amazon.com/api/", search).
next_state(browseProduct, search,"http://www.amazon.com/api/search", product).
next_state(browseProduct, product,"http://www.amazon.com/api/product", end).
next_state(checkoutBasket, entry,"http://www.amazon.com/api/", basket).
next_state(checkoutBasket, basket,"http://www.amazon.com/api/basket", checkout).
next_state(checkoutBasket, checkout,"http://www.amazon.com/api/checkout", payment).
next_state(checkoutBasket, payment,"http://www.amazon.com/api/payment", end).
next_state(browseBasket, entry,"http://www.amazon.com/api/", basket).
  next_state(browseBasket, basket,"http://www.amazon.com/api/basket", end).


status_code("http://www.amazon.com/api/product", 200).
status_code("http://www.amazon.com/api/basket", 200).
status_code("http://www.amazon.com/api/checkout", 200).
status_code("http://www.amazon.com/api/payment", 200).
status_code("http://www.amazon.com/api/search", 200).
