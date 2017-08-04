path(basket, "http://www.amazon.com/api/basket",get).
path(basket, "http://www.amazon.com/api/basket",post).
path(search, "http://www.amazon.com/api/search",get).
path(search, "http://www.amazon.com/api/search",post).
path(product, "http://www.amazon.com/api/product",get).
path(checkout, "http://www.amazon.com/api/checkout",get).
path(payment, "http://www.amazon.com/api/payment",get).
path(product, "http://www.amazon.com/api/product",get).
path(product, "http://www.amazon.com/api/product",get).

next_state(entry," ", search).
next_state(search,"http://www.amazon.com/api/search", product).
next_state(product,"http://www.amazon.com/api/product", basket).
next_state(basket,"http://www.amazon.com/api/basket", checkout).
next_state(checkout,"http://www.amazon.com/api/checkout", payment).
next_state(payment,"http://www.amazon.com/api/payment", receipt).

status_code("http://www.amazon.com/api/product", 200).
status_code("http://www.amazon.com/api/basket", 200).
status_code("http://www.amazon.com/api/checkout", 200).
status_code("http://www.amazon.com/api/payment", 200).
status_code("http://www.amazon.com/api/search", 200).
