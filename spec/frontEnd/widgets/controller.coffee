numberOfPosts = 2
newController = (container, defaultValue) ->
  new Blog.Widgets.Controller({container: container, defaultValue: defaultValue, numberOfPosts: numberOfPosts})

container = '[data-id=container1]'
setupOneContainer = ->
  setFixtures "<div data-id='container1'></div>"

mockPosts = [
  {
    title: 'Title 1',
    author: 'Author 1',
    link: 'link to post',
    image: {
      url: 'spec/mockImages/001.jpeg',
      title: 'Imaginary Friend1',
      link: 'link/to/authors/profile'
    }
  },{
    title: 'Title 2',
    author: 'Author 2',
    link: 'link to post',
    image: {
      url: 'spec/mockImages/002.jpeg',
      title: 'Imaginary Friend2',
      link: 'link/to/authors/profile'
    }
  }
]

jsonResponse = JSON.stringify(mockPosts)

clickButtonIn = (container) ->
  $("#{container} blog-button").click()

describe "Blog.Widgets.Controller", ->
  it "stores the container that it is initialized with", ->
    controller = newController('some-container')
    expect(controller.getContainer()).toEqual('some-container')

  it "stores a new instance of Blog.Widgets.Display", ->
    spy = spyOn(Blog.Widgets, 'Display').and.callThrough()
    controller = new Blog.Widgets.Controller({container: 'some-container', numberOfPosts: numberOfPosts, animationSpeed: 300 })
    expect(spy).toHaveBeenCalledWith('some-container', numberOfPosts, 300)
    expect(controller.display).toBeDefined()

  describe "initialize", ->
    controller = undefined
    beforeEach ->
      setupOneContainer()
      controller = newController(container)

    it "sets widget up in its container", ->
      controller.initialize()
      expect($(container)).not.toBeEmpty()

    it "is binding the click events", ->
      controller.initialize()
      server = sinon.fakeServer.create()
      server.respondWith(/.+/, jsonResponse)
      $('[name=blog-search]').val('some/url/here')
      $('[data-id=blog-button]').click()
      server.respond()
      expect($('.blog-post')).toBeInDOM()
      server.restore()

    it "is setting the widget as active", ->
      controller.initialize()
      expect(controller.isActive()).toBe(true)

    it "is displaying data if a default value is provided", ->
      controller = newController(container, "defaultValue")
      spy = spyOn(Blog.Widgets.Api, 'getBlogPosts')
      controller.initialize()
      expect(spy).toHaveBeenCalledWith("defaultValue", controller.display)

    it "is NOT displaying data if a default value is NOT provided", ->
      controller = newController(container)
      spy = spyOn(Blog.Widgets.Api, 'getBlogPosts')
      controller.initialize()
      expect(spy).not.toHaveBeenCalled()

  describe "bind", ->
    it "is calling api with the url in the input field and the display", ->
      setupOneContainer()
      controller = newController(container)
      controller.initialize()
      $('[name=blog-search]').val('some/url/here')
      spy = spyOn(Blog.Widgets.Api, 'getBlogPosts')
      $('[data-id=blog-button]').click()
      expect(spy).toHaveBeenCalledWith('some/url/here', controller.display)

    it "removes the widget when close widget button is clicked", ->
      setupOneContainer()
      controller = newController(container)
      controller.initialize()
      expect($('[data-id=blog-widget-wrapper]')).toBeInDOM()
      $('[data-id=blog-close]').click()
      expect($('[data-id=blog-widget-wrapper]')).not.toBeInDOM()

  it "closeWidget is setting the widget as inactive", ->
    setupOneContainer()
    controller = newController(container)
    controller.initialize()
    controller.closeWidget()
    expect(controller.isActive()).toBe(false)

  it "closeWidget is unbinding the controller", ->
    setupOneContainer()
    controller = newController(container)
    controller.initialize()
    spyOn(controller, 'unbind')
    controller.closeWidget()
    expect(controller.unbind).toHaveBeenCalled()

  it "hideForm is hiding the form", ->
    setupOneContainer()
    controller = newController(container)
    controller.initialize()
    controller.hideForm()
    expect($('[data-id=blog-form]').attr('style')).toEqual('display: none;')

  it "showForm is showing the form" , ->
    setupOneContainer()
    controller = newController(container)
    controller.initialize()
    controller.hideForm()
    expect($('[data-id=blog-form]').attr('style')).toEqual('display: none;')
    controller.showForm()
    expect($('[data-id=blog-form]').attr('style')).not.toEqual('display: none;')

  describe "unbind", ->
    it "unbind is unbinding the form click event", ->
      setupOneContainer()
      controller = newController(container)
      controller.initialize()
      spy = spyOn(Blog.Widgets.Api, 'getBlogPosts')
      controller.unbind()
      $('[data-id=blog-button]').click()
      expect(spy).not.toHaveBeenCalled()

    it "unbind is unbinding the closeWidget click event", ->
      setupOneContainer()
      controller = newController(container)
      controller.initialize()
      controller.unbind()
      $('[data-id=blog-close]').click()
      expect($(container)).toBeInDOM()
