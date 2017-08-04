'use strict';
var mongoose = require('mongoose');
var Schema = mongoose.Schema;


var ProductSchema = new Schema({
  name: {
    type: String,
    Required: 'Kindly enter the name of the product'
  },
  Added_date: {
    type: Date,
    default: Date.now
  },
  Description: {
    type: String,
    Required: 'Please add a description of the product'
  },
  Product_type: {
    type: String,
    default: "other"
  },
  Price: {
    type: Number  
  }
});

module.exports = mongoose.model('Products', ProductSchema);
