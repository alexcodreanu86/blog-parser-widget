express = require('express')
request = require('request')
url = require('url')
FeedParser = require('feedparser')

fs = require('fs')
path = require('path')
util = require('util')
app = express()

app.use(express.static(__dirname))
app.set('views', path.join(__dirname, 'views'))
app.set('view engine', 'ejs')

app.get '/', (request, response) ->
  response.render 'index', {title: "Blog-Scrapper-Widget"}

app.post '/blog_feed', (req, res) ->
  urlData = undefined
  req.on('data', (data) ->
    urlData = data
  )
  req.on('end', ->
    url = JSON.parse(urlData).url
    processRequest(url, res)
  )

processRequest = (url, response) ->
  data = []
  feedRequest = request(url)
  feedParser = new FeedParser()
  feedRequest.on('response', (resp) ->
    this.pipe(feedParser)
  )

  feedParser.on('readable', ->
    data.push(item) while item = this.read()
  )

  feedParser.on('end', ->
    console.log data[2]
    response.send(data)
  )

server = app.listen 5000, ->
  console.log "listening on port #{server.address().port}"

exports = module.exports = app

