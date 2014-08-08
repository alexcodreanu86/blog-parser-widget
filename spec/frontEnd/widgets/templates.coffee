mockPost1 = {
    title: 'Title 1',
    author: 'Author 1',
    link: 'link to post',
    image: {
      url: 'spec/mockImages/001.jpeg',
      title: 'Imaginary Friend1',
      link: 'link/to/authors/profile'
    }
  }

mockPost2 = {
    title: 'Title 2',
    author: 'Author 2',
    link: 'link to post',
    image: {
      url: 'spec/mockImages/002.jpeg',
      title: 'Imaginary Friend2',
      link: 'link/to/authors/profile'
    }
  }

mockPosts = [mockPost1, mockPost2]
describe 'Blog.Widgets.Templates', ->
  it 'renderForm is rendering the proper html for the form', ->
    formHtml = Blog.Widgets.Templates.renderForm()
    setFixtures sandbox()
    $('#sandbox').append(formHtml)
    expect(formHtml).toContainElement('[name=blog-search]')
    expect(formHtml).toContainElement('[data-id=blog-button]')
    expect(formHtml).toContainElement('[data-id=blog-output]')

  it 'renderPosts is rendering proper html for one post', ->
    setFixtures sandbox()
    display = new Blog.Widgets.Display('#sandbox')
    formatedPosts = display.formatAllPosts([mockPost1])
    postsHtml = Blog.Widgets.Templates.renderPosts(formatedPosts)
    $('#sandbox').append(postsHtml)
    expect($('#sandbox')).toContainElement('.blog-post-title')
    expect($('.blog-post-title')).toContainText('Title 1')
    expect($('.blog-image').attr('src')).toEqual('spec/mockImages/001.jpeg')
    expect($('.blog-image').attr('alt')).toEqual('Imaginary Friend1')
    expect($('.post-author-name').attr('href')).toEqual('link/to/authors/profile')
    expect($('.post-author-name')).toContainText('Author 1')

  it 'renderPosts is rendering proper html for all the posts', ->
    setFixtures sandbox()
    display = new Blog.Widgets.Display('#sandbox')
    formatedPosts = display.formatAllPosts(mockPosts)
    postsHtml = Blog.Widgets.Templates.renderPosts(formatedPosts)
    $('#sandbox').append(postsHtml)
    expect($('.blog-post-title')[0]).toContainText('Title 1')
    expect($('.blog-post-title')[1]).toContainText('Title 2')
