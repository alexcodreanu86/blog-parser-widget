namespace("Blog.Widgets")

class Blog.Widgets.Controller
  constructor: (settings) ->
    @container    = settings.container
    @defaultValue = settings.defaultValue
    @display      = new Blog.Widgets.Display(settings.container, settings.numberOfPosts, settings.animationSpeed)
    @refreshRate  = settings.refreshRate
    @activeStatus = false

  initialize: ->
    @display.setupWidget()
    @bind()
    @setAsActive()
    @displayDefault()

  bind: ->
    $("#{@container} [data-name=widget-form]").on 'submit', (e) =>
      e.preventDefault()
      @processClickedButton()
    $("#{@container} [data-name=widget-close]").click( => @closeWidget())

  unbind: ->
    $("#{@container} [data-name=widget-form]").unbind('submit')
    $("#{@container} [data-name=widget-close]").unbind('click')

  closeWidget: ->
    @display.removeWidget()
    @setAsInactive()
    @unbind()

  processClickedButton: ->
    input = @display.getInput()
    if Blog.Widgets.Validator.isValidUrl(input)
      @getBlogPosts(input)

  getBlogPosts: (input) ->
    Blog.Widgets.Api.getBlogPosts(input, @display)
    if @refreshRate
      @clearCurrentTimeout()
      @refreshBlogPosts(input)

  clearCurrentTimeout: ->
    clearTimeout(@timeout) if @timeout

  refreshBlogPosts: (input) ->
    @timeout = setTimeout( =>
      @getBlogPosts(input) if @isActive()
    , @refreshSeconds())

  refreshSeconds: ->
    @refreshRate * 1000

  displayDefault: ->
    if @defaultValue
      @getBlogPosts(@defaultValue)

  isActive: ->
    @activeStatus

  setAsActive: ->
    @activeStatus = true

  setAsInactive: ->
    @activeStatus = false
