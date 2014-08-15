namespace('Blog.Widgets')

class Blog.Widgets.Validator
  @isValidUrl: (url) ->
    !!@matchUrl(url)

  @matchUrl: (url) ->
    url.match(/http\:\/\/\w+\.\w+/)
