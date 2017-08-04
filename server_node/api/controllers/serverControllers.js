'use strict';

var mongoose = require('mongoose'),
    path = require('path'),
    Product = mongoose.model('Products');

exports.list_all_products = function(req, res) {
  Product.find({}, function(err, product) {
    console.log('Listing all products');
    if (err)
      res.send(err);
    res.json(product);
  });
};


exports.create_a_product = function(req, res) {
  var new_product = new Product(req.body);
  new_product.save(function(err, product) {
    console.log('Creating new product');
    if (err)
      res.send(err);
    res.json(product);
  });
};

exports.send_graph = function(req, res){
  console.log('Sending automato');
  res.sendFile(path.join(__dirname, '../../data', 'graph.pl'));
}


exports.read_a_product = function(req, res) {
  Product.findById(req.params.productId, function(err, product) {
    console.log('Show product by id');
    if (err)
      res.send(err);
    res.json(product);
  });
};

//var regex = new RegExp(req.params.body, 'i');  // 'i' makes it case insensitive
exports.search_a_product = function(req,res){
    Product.find({name : RegExp(req.query.name, 'i')}, function(err,product){
        console.log('Searching product by name');
        if (err)
          res.send(err);
        res.json(product);
    });
};

exports.update_a_product = function(req, res) {
  Product.findOneAndUpdate({_id: req.params.productId}, req.body, {new: true}, function(err, product) {
    console.log('Updating product'+req.params.productId);
    if (err)
      res.send(err);
    res.json(product);
  });
};


exports.delete_a_product = function(req, res) {
  console.log('Deleting product '+req.params.productId);
  Product.remove({
    _id: req.params.productId
  }, function(err, product) {
    if (err)
      res.send(err);
    res.json({ message: 'product successfully deleted' });
  });
};
