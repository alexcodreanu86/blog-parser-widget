namespace("Blog.Widgets")

class Blog.Widgets.Controller
  constructor: (settings) ->
    @container    = settings.container
    @defaultValue = settings.defaultValue
    @display      = new Blog.Widgets.Display(settings.container, settings.numberOfPosts, settings.animationSpeed)
    @refreshRate  = settings.refreshRate
    @activeStatus = false

  getContainer: ->
    @container

  initialize: ->
    @display.setupWidget()
    @bind()
    @setAsActive()
    @displayDefault()

  bind: ->
    $("#{@container} [data-id=blog-button]").click( => @processClickedButton())
    $("#{@container} [data-id=blog-close]").click( => @closeWidget())

  unbind: ->
    $("#{@container} [data-id=blog-button]").unbind('click')
    $("#{@container} [data-id=blog-close]").unbind('click')

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

  exitEditMode: ->
    @display.exitEditMode()

  enterEditMode: ->
    @display.enterEditMode()
