describe "Blog.Controller", ->
  it "setupWidgetIn sets up the widget in the given container", ->
    setFixtures '<div data-id="widget-container-1"></div>'
    Blog.Controller.setupWidgetIn({container: '[data-id=widget-container-1]'})
    expect($('[data-id=widget-container-1]')).toContainElement('[name=widget-input]')
