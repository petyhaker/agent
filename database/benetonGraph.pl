path(basket, "http://www.beneton.com/basket",get).
path(basket, "http://www.beneton.com/basket",post).
path(search, "http://www.beneton.com/search",get).
path(search, "http://www.beneton.com/search",post).
path(product, "http://www.beneton.com/product",get).
path(checkout, "http://www.beneton.com/checkout",get).
path(payment, "http://www.beneton.com/payment",get).
path(product, "http://www.beneton.com/product",get).
path(product, "http://www.beneton.com/product",get).

next_state(entry, " ",search).
next_state(search,"http://www.beneton.com/search", product).
next_state(product,"http://www.beneton.com/product",  basket).
next_state(basket, "http://www.beneton.com/basket", checkout).
next_state(checkout,"http://www.beneton.com/checkout", payment).
next_state(payment,"http://www.beneton.com/payment", receipt).

status_code("http://www.beneton.com/product", 200).
status_code("http://www.beneton.com/basket", 200).
status_code("http://www.beneton.com/checkout", 200).
status_code("http://www.beneton.com/payment", 200).
status_code("http://www.beneton.com/search", 400).
