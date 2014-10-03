namespace("Blog")

class Blog.Controller
  @setupWidgetIn: (settings) ->
    new Blog.Widgets.Controller(settings).initialize()
