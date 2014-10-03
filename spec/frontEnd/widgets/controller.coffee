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

jsonResponse  = JSON.stringify(mockPosts)
validUrl      = "http://some.com/url/here"
invalidUrl    = "some.com/url/here"

describe "Blog.Widgets.Controller", ->
  it "stores the container that it is initialized with", ->
    controller = newController('some-container')
    expect(controller.container).toEqual('some-container')

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
      $('[name=widget-input]').val(validUrl)
      $('[data-name=form-button]').click()
      server.respond()
      expect($('.blog-post')).toBeInDOM()
      server.restore()


    it "sets the widget as active", ->
      controller.initialize()
      expect(controller.isActive()).toBe(true)

    it "displayes data if a default value is provided", ->
      controller = newController(container, "defaultValue")
      spy = spyOn(Blog.Widgets.Api, 'getBlogPosts')
      controller.initialize()
      expect(spy).toHaveBeenCalledWith("defaultValue", controller.display)

    it "does NOT display data if a default value is NOT provided", ->
      controller = newController(container)
      spy = spyOn(Blog.Widgets.Api, 'getBlogPosts')
      controller.initialize()
      expect(spy).not.toHaveBeenCalled()

  describe "processClickedButton", ->
    it "gets blog posts if url is invalid", ->
      setupOneContainer()
      controller = newController(container)
      controller.initialize()
      spy = spyOn(Blog.Widgets.Api, 'getBlogPosts')
      $('[name=widget-input]').val(invalidUrl)
      controller.processClickedButton()
      expect(spy).not.toHaveBeenCalled()

    it "gets blog posts if url is valid", ->
      setupOneContainer()
      controller = newController(container)
      controller.initialize()
      spy = spyOn(Blog.Widgets.Api, 'getBlogPosts')
      $('[name=widget-input]').val(validUrl)
      controller.processClickedButton()
      expect(spy).toHaveBeenCalled()

  describe "bind", ->
    it "calls api with the url in the input field and the display", ->
      setupOneContainer()
      controller = newController(container)
      controller.initialize()
      $('[name=widget-input]').val(validUrl)
      spy = spyOn(Blog.Widgets.Api, 'getBlogPosts')
      $('[data-name=form-button]').click()
      expect(spy).toHaveBeenCalledWith(validUrl, controller.display)

    it "removes the widget when close widget button is clicked", ->
      setupOneContainer()
      controller = newController(container)
      controller.initialize()
      expect($('[data-name=widget-wrapper]')).toBeInDOM()
      $('[data-name=widget-close]').click()
      expect($('[data-name=widget-wrapper]')).not.toBeInDOM()

  it "closeWidget sets the widget as inactive", ->
    setupOneContainer()
    controller = newController(container)
    controller.initialize()
    controller.closeWidget()
    expect(controller.isActive()).toBe(false)

  it "closeWidget unbinds the controller", ->
    setupOneContainer()
    controller = newController(container)
    controller.initialize()
    spyOn(controller, 'unbind')
    controller.closeWidget()
    expect(controller.unbind).toHaveBeenCalled()


  describe "unbind", ->
    it "unbinds the form submit event", ->
      controller = newController(container)
      controller.initialize()
      spy = spyOn($.prototype, 'unbind')
      controller.unbind()
      expect(spy).toHaveBeenCalledWith('submit')

    it "unbinds the closeWidget click event", ->
      setupOneContainer()
      controller = newController(container)
      controller.initialize()
      controller.unbind()
      $('[data-name=widget-close]').click()
      expect($(container)).toBeInDOM()

  describe "refreshBlogs", ->
    controller = undefined
    spy        = undefined
    oneMinute  = 60 * 1000

    newRefreshController = (container, refreshRate) ->
      new Blog.Widgets.Controller({container: container, numberOfPosts: numberOfPosts, refreshRate: refreshRate})

    beforeEach ->
      controller = newRefreshController(container, 50)
      controller.setAsActive()
      spy = spyOn(Blog.Widgets.Api, 'getBlogPosts')
      jasmine.clock().install()

    afterEach ->
      jasmine.clock().uninstall()

    it "does NOT refresh when no refresh rate is provided", ->
      controller = newRefreshController(container, undefined)
      controller.getBlogPosts('some/url/here')
      expect(spy.calls.count()).toBe(1)
      jasmine.clock().tick(oneMinute)
      expect(spy.calls.count()).toBe(1)

    it "refreshes when a refresh value is given", ->
      controller.getBlogPosts('some/url/here')
      expect(spy.calls.count()).toBe(1)
      jasmine.clock().tick(oneMinute)
      expect(spy.calls.count()).toBe(2)

    it "does NOT refresh if widget is closed", ->
      controller.getBlogPosts('some/url/here')
      expect(spy.calls.count()).toBe(1)
      controller.closeWidget()
      jasmine.clock().tick(oneMinute)
      expect(spy.calls.count()).toBe(1)

    it "refreshes only for the newest search", ->
      controller.getBlogPosts('some/url/here')
      expect(spy.calls.argsFor(0)[0]).toEqual('some/url/here')
      controller.getBlogPosts('some/other/url/here')
      expect(spy.calls.argsFor(1)[0]).toEqual('some/other/url/here')
      jasmine.clock().tick(oneMinute)
      expect(spy.calls.argsFor(2)[0]).toEqual('some/other/url/here')
      expect(spy.calls.count()).toBe(3)
