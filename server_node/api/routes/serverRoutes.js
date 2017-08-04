'use strict';
module.exports = function(app) {
  var server = require('../controllers/serverControllers');


  app.route('/')
    .get(server.send_graph);
  app.route('/api')
    .get(server.send_graph);

  app.route('/products')
    .get(server.list_all_products)
    .post(server.create_a_product);

  app.route('/search')
    .get(server.search_a_product);

  app.route('/products/:productId')
    .get(server.read_a_product)
    .put(server.update_a_product)
    .delete(server.delete_a_product);
};
