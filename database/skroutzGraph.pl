path(basket, "http://www.skroutz.com/api/basket",get).
path(basket, "http://www.skroutz.com/api/basket",post).
path(search, "http://www.skroutz.com/api/search",get).
path(search, "http://www.skroutz.com/api/search",post).
path(product, "http://www.skroutz.com/api/product",get).
path(checkout, "http://www.skroutz.com/api/checkout",get).
path(payment, "http://www.skroutz.com/api/payment",get).
path(product, "http://www.skroutz.com/api/product",get).
path(product, "http://www.skroutz.com/api/product",get).

next_state(entry," ", search).
next_state(search,"http://www.skroutz.com/api/search", product).
next_state(product,"http://www.skroutz.com/api/product", basket).
next_state(basket,"http://www.skroutz.com/api/basket", checkout).
next_state(checkout,"http://www.skroutz.com/api/checkout",  payment).
next_state(payment,"http://www.skroutz.com/api/payment", receipt).

status_code("http://www.skroutz.com/api/product", 200).
status_code("http://www.skroutz.com/api/basket", 200).
status_code("http://www.skroutz.com/api/checkout", 200).
status_code("http://www.skroutz.com/api/payment", 200).
status_code("http://www.skroutz.com/api/search", 200).
