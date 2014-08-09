namespace('Blog')

class Blog.Display
  @generateLogo: (settings) ->
    "<i class=\"fa fa-book #{settings.class}\" data-id=\"#{settings.dataId}\"></i>"
