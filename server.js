(function() {
  var FeedParser, app, exports, express, fs, path, processRequest, request, server, url, util;

  express = require('express');

  request = require('request');

  url = require('url');

  FeedParser = require('feedparser');

  fs = require('fs');

  path = require('path');

  util = require('util');

  app = express();

  app.use(express["static"](__dirname));

  app.set('views', path.join(__dirname, 'views'));

  app.set('view engine', 'ejs');

  app.get('/', function(request, response) {
    return response.render('index', {
      title: "Blog-Scrapper-Widget"
    });
  });

  app.post('/blog_feed', function(req, res) {
    var urlData;
    urlData = void 0;
    req.on('data', function(data) {
      return urlData = data;
    });
    return req.on('end', function() {
      url = JSON.parse(urlData).url;
      return processRequest(url, res);
    });
  });

  processRequest = function(url, response) {
    var data, feedParser, feedRequest;
    data = [];
    feedRequest = request(url);
    feedParser = new FeedParser();
    feedRequest.on('response', function(resp) {
      return this.pipe(feedParser);
    });
    feedParser.on('readable', function() {
      var item, _results;
      _results = [];
      while (item = this.read()) {
        _results.push(data.push(item));
      }
      return _results;
    });
    return feedParser.on('end', function() {
      console.log(data[2]);
      return response.send(data);
    });
  };

  server = app.listen(5000, function() {
    return console.log("listening on port " + (server.address().port));
  });

  exports = module.exports = app;

}).call(this);
