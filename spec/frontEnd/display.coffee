describe "Blog.Display", ->
  it "generateLogo returns the logo with the given data-id", ->
    logo = Blog.Display.generateLogo({dataId: 'some-data-id', class: 'some-class'})
    expect(logo).toEqual('<i class="fa fa-book some-class" data-id="some-data-id"></i>')

