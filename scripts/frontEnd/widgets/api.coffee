namespace('Blog.Widgets')

class Blog.Widgets.Api
  @getBlogPosts: (url, displayer) ->
    jsonData = JSON.stringify({url: url})
    $.post('/blog_feed', jsonData, (response) ->
      displayer.showPosts(response)
    ,'json')
