# agent

Instructions:

1. Open terminal or cmd and type "swipl"
2. In the prompt type "consult(agent)"
3. Call the agent by "agent(INTENSION, SCOPE, SEARCHBY, VALUE)"
  INTENSION can be one of the following values: buyProduct, browseProduct, checkoutBasket, browseBasket
  SCOPE can be one of the following values: all, "http://www.amazon.com/api/",  "http://www.skroutz.com/api/", "http://www.foo.com/api/", "http://www.beneton.com/".
  !NOTE that Scope has to be in the following form ["http://www.smth.com/", ..., end_of_file]
  SEARCHBY is the parameters to insert in the http request. Valid values: ["usename", "password"] - basket, ["name"] - product, ["basketId"] - checkout, ["creditCard_number", "postage_info"] - payment

Example calls:

- agent(browseBasket, ["http://www.amazon.com/api/", end_of_file], ["username", "password"], ["vasiliki", "verysecurepassword"]).

- agent(buyProduct, all, "name", "Moby Dick").
- agent(buyProduct, all, "name", "Foo Book").
