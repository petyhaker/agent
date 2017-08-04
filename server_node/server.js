var express = require('express'),
    bodyParser = require('body-parser'),
    mongoose = require('mongoose'),
    Product = require('./api/models/serverModels'),
    app = express(),
    port = process.env.PORT || 3000;


mongoose.Promise = global.Promise;
mongoose.connect('mongodb://vasiliki:papoutsi42@ds131583.mlab.com:31583/online_store');

app.use(bodyParser.urlencoded({ extended: true }));
app.use(bodyParser.json());

var routes = require('./api/routes/serverRoutes');
routes(app);


app.listen(port, function(){
    console.log('Express server listening on port 4567');
});
