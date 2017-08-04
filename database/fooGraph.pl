path(basket, "http://www.foo.com/api/basket",get).
path(basket, "http://www.foo.com/api/basket",post).
path(search, "http://www.foo.com/api/search",get).
path(search, "http://www.foo.com/api/search",post).
path(product, "http://www.foo.com/api/product",get).
path(checkout, "http://www.foo.com/api/checkout",get).
path(payment, "http://www.foo.com/api/payment",get).
path(product, "http://www.foo.com/api/product",get).
path(product, "http://www.foo.com/api/product",get).

next_state(entry, " ", search).
next_state(search,"http://www.foo.com/api/search",  product).
next_state(product,"http://www.foo.com/api/product", basket).
next_state(basket,"http://www.foo.com/api/basket", checkout).
next_state(checkout,"http://www.foo.com/api/checkout",  payment).
next_state(payment,"http://www.foo.com/api/payment", receipt).

status_code("http://www.foo.com/api/product", 200).
status_code("http://www.foo.com/api/basket", 200).
status_code("http://www.foo.com/api/checkout", 200).
status_code("http://www.foo.com/api/payment", 500).
status_code("http://www.foo.com/api/search", 200).
