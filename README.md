# agent

Instructions:

1. Open terminal or cmd and type "swipl"
2. In the prompt type "consult(agent_new)"
3. Call the agent by "start(INTENSION, SCOPE, Result)"
  INTENSION can be one of the following values: buyProduct, browseProduct, checkoutBasket, browseBasket
  SCOPE can be one of the following values: all, "http://www.amazon.com/api/",  "http://www.skroutz.com/api/", "http://www.foo.com/api/", "http://www.beneton.com/".
  Result is a variable to return the result.
