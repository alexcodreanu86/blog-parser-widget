namespace("Blog")

class Blog.Controller
  @widgets = []

  @getWidgets: ->
    @widgets

  @setupWidgetIn: (settings) ->
    newWidget = new Blog.Widgets.Controller(settings)
    newWidget.initialize()
    @addWidgetToContainer(newWidget)

  @addWidgetToContainer: (newWidget) ->
    @widgets.push(newWidget)

  @exitEditMode: ->
    @allActiveWidgetsExecute('exitEditMode')

  @enterEditMode: ->
    @allActiveWidgetsExecute('enterEditMode')

  @allActiveWidgetsExecute: (command) ->
    _.each(@widgets, (widget)  =>
      if widget.isActive()
        widget[command]()
    )
