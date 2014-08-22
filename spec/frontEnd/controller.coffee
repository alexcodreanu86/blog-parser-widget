resetWidgets = ->
  Blog.Controller.widgets = []

container1 = '[data-id=widget-container-1]'
container2 = '[data-id=widget-container-2]'

setupOneContainer = ->
  setFixtures '<div data-id="widget-container-1"></div>'

setupTwoContainers = ->
  setFixtures """
    <div data-id='widget-container-1'></div>
    <div data-id='widget-container-2'></div>
  """

describe "Blog.Controller", ->
  it "widgets container is empty on start", ->
    expect(Blog.Controller.getWidgets().length).toBe(0)

  it "setupWidgetIn sets up the widget in the given container", ->
    setupOneContainer()
    Blog.Controller.setupWidgetIn({container: container1})
    expect($(container1)).toContainElement('[name=blog-search]')

  it "setupWidgetIn adds the new widget to the widgets container", ->
    resetWidgets()
    setupOneContainer()
    expect(Blog.Controller.getWidgets().length).toBe(0)
    Blog.Controller.setupWidgetIn({container: container1})
    expect(Blog.Controller.getWidgets().length).toBe(1)

  it "exitEditMode is hiding the forms of all the active widgets", ->
    resetWidgets()
    setupTwoContainers()
    Blog.Controller.setupWidgetIn({container: container1})
    Blog.Controller.setupWidgetIn({container: container2})
    Blog.Controller.exitEditMode()
    expect($("#{container1} [data-id=blog-close]").attr('style')).toEqual('display: none;')
    expect($("#{container2} [data-id=blog-close]").attr('style')).toEqual('display: none;')

  it "enterEditMode is showing the forms of all the active widgets", ->
    resetWidgets()
    setupTwoContainers()
    Blog.Controller.setupWidgetIn({container: container1})
    Blog.Controller.setupWidgetIn({container: container2})
    Blog.Controller.exitEditMode()
    expect($("#{container1} [data-id=blog-close]").attr('style')).toEqual('display: none;')
    expect($("#{container2} [data-id=blog-close]").attr('style')).toEqual('display: none;')
    Blog.Controller.enterEditMode()
    expect($("#{container1} [data-id=blog-close]").attr('style')).not.toEqual('display: none;')
    expect($("#{container2} [data-id=blog-close]").attr('style')).not.toEqual('display: none;')

  it "setupWidgetIn is passing the settings to the widgets controller", ->
    resetWidgets()
    Blog.Controller.setupWidgetIn({container: "some container"})
    expect(Blog.Controller.getWidgets()[0].container).toEqual('some container')
