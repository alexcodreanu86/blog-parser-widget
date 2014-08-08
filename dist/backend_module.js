(function() {
  var BlogXmlParser, FeedParser, cheerio, request, url;

  request = require('request');

  url = require('url');

  cheerio = require('cheerio');

  FeedParser = require('feedparser');

  BlogXmlParser = (function() {
    function BlogXmlParser() {}

    BlogXmlParser.formatItemData = function(item) {
      var formatedItem;
      formatedItem = {};
      formatedItem.title = item.title;
      formatedItem.blogLink = item.link;
      formatedItem.imageSrc = item.image.url;
      formatedItem.imageAlt = item.image.title;
      formatedItem.authorLink = item.image.link;
      return formatedItem;
    };

    return BlogXmlParser;

  })();

  module.exports = BlogXmlParser;

}).call(this);
