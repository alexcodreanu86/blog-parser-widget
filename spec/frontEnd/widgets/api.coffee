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

describe 'Blog.Widgets.Api', ->
  it "getBlogPosts is passing the data received to displayer.showPosts", ->
    setFixtures sandbox()
    display = new Blog.Widgets.Display('#sandbox')
    display.setupWidget()
    spyOn(display, 'showPosts')
    server = sinon.fakeServer.create()
    server.respondWith(/.+/, jsonResponse)
    Blog.Widgets.Api.getBlogPosts('http://google.com', display)
    server.respond()
    expect(display.showPosts).toHaveBeenCalledWith(mockPosts)
    server.restore()

  it "getBlogPosts let's the displayer display data", ->
    setFixtures sandbox()
    display = new Blog.Widgets.Display('#sandbox')
    display.setupWidget()
    server = sinon.fakeServer.create()
    server.respondWith(/.+/, jsonResponse)
    Blog.Widgets.Api.getBlogPosts('http://google.com', display)
    server.respond()
    expect($('.blog-post')).toBeInDOM()
    server.restore()
