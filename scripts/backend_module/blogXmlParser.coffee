request = require('request')
url = require('url')
cheerio = require('cheerio')
FeedParser = require('feedparser')

class BlogXmlParser
  @formatItemData: (item) ->
    formatedItem            = {}
    formatedItem.title      = item.title
    formatedItem.blogLink   = item.link
    formatedItem.imageSrc   = item.image.url
    formatedItem.imageAlt   = item.image.title
    formatedItem.authorLink = item.image.link

    formatedItem

module.exports = BlogXmlParser
