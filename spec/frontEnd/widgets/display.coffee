container1 = '[data-id=widget-container-1]'
container2 = '[data-id=widget-container-2]'
setupOneContainer = ->
  setFixtures '<div data-id="widget-container-1"></div>'

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

setupTwoContainers = ->
  setFixtures """
    <div data-id='widget-container-1'></div>
    <div data-id='widget-container-2'></div>
  """

newDisplay = (container) ->
   new Blog.Widgets.Display(container)

describe 'Blog.Widgets.Display', ->
  it 'stores the container it is initialized with', ->
    display = newDisplay(container1)
    expect(display.container).toEqual(container1)

  it 'setupWidget is setting up the widget in it\'s container', ->
    setupOneContainer()
    display = newDisplay container1
    display.setupWidget()
    expect($(container1)).toContainElement('.widget .widget-header')

  it 'getInput returns the text in the form field', ->
    setupOneContainer()
    display = newDisplay(container1)
    display.setupWidget()
    $('[name=blog-search]').val('some-value-here')
    expect(display.getInput()).toEqual('some-value-here')

  it 'getInput returns the value of the input in it\'s container', ->
    setupTwoContainers()
    display1 = newDisplay(container1)
    display2 = newDisplay(container2)
    display1.setupWidget()
    display2.setupWidget()
    $("#{container1} [name=blog-search]").val('value1')
    $("#{container2} [name=blog-search]").val('value2')
    expect(display1.getInput()).toEqual('value1')
    expect(display2.getInput()).toEqual('value2')

  it 'showPosts is displaying the posts given', ->
    setupOneContainer()
    display = newDisplay(container1)
    display.setupWidget()
    display.showPosts(mockPosts)
    expect('.blog-post-title').toBeInDOM()

  it 'formatAllPosts returns formated posts information', ->
    display = newDisplay(container1)
    formatedData = display.formatAllPosts(mockPosts)
    expect(formatedData[0].imageAlt).toEqual('Imaginary Friend1')
    expect(formatedData[1].imageAlt).toEqual('Imaginary Friend2')

  it 'formatPost is formating the required fields', ->
    display = newDisplay(container1)
    formatedPost = display.formatPost(mockPosts[0])
    expect(formatedPost.title).toEqual('Title 1')
    expect(formatedPost.authorName).toEqual('Author 1')
    expect(formatedPost.blogLink).toEqual('link to post')
    expect(formatedPost.imageSrc).toEqual('spec/mockImages/001.jpeg')
    expect(formatedPost.imageAlt).toEqual('Imaginary Friend1')
    expect(formatedPost.authorLink).toEqual('link/to/authors/profile')

  it 'removeWidget is removing the widget content from the dom', ->
    setupOneContainer()
    display = newDisplay container1
    display.setupWidget()
    expect($(container1)).toContainElement('.widget .widget-header')
    display.removeWidget()
    expect($(container1)).not.toBeInDOM()

  it "exitEditMode is hiding the form", ->
    setupOneContainer()
    display = newDisplay container1
    display.setupWidget()
    display.exitEditMode()
    expect($('[data-id=blog-form]').attr('style')).toEqual('display: none;')

  it "exitEditMode is hiding the close-button", ->
    setupOneContainer()
    display = newDisplay container1
    display.setupWidget()
    display.exitEditMode()
    expect($('[data-id=blog-close]').attr('style')).toEqual('display: none;')

  it "enterEditMode is showing the form", ->
    setupOneContainer()
    display = newDisplay container1
    display.setupWidget()
    display.exitEditMode()
    expect($('[data-id=blog-form]').attr('style')).toEqual('display: none;')
    display.enterEditMode()
    expect($('[data-id=blog-form]').attr('style')).not.toEqual('display: none;')

  it "enterEditMode is showing the close-button", ->
    setupOneContainer()
    display = newDisplay container1
    display.setupWidget()
    display.exitEditMode()
    expect($('[data-id=blog-close]').attr('style')).toEqual('display: none;')
    display.enterEditMode()
    expect($('[data-id=blog-close]').attr('style')).not.toEqual('display: none;')
