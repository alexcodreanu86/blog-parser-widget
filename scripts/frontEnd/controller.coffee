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

  @hideForms: ->
    @allActiveWidgetsExecute('hideForm')

  @showForms: ->
    @allActiveWidgetsExecute('showForm')

  @allActiveWidgetsExecute: (command) ->
    _.each(@widgets, (widget)  =>
      if widget.isActive()
        widget[command]()
    )
