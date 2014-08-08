BlogXmlParser = require '../../scripts/backend_module/blogXmlParser.coffee'

describe "BlogXmlParser", ->

  items = [{
      title: "First Title",
      link: "some/link/here",
      author: {name: "John Doe"}
      image: {
        link: "http://google.com/author1",
        url: "mockImages/img1.jpeg",
        title: "Image1 title here"
      }
    }, {
      title: "Second Title",
      link: "some/link/here",
      author: {name: "Not John Doe"}
      image: {
        link: "http://google.com/author2",
        url: "mockImages/img2.jpeg",
        title: "Image2 title here"
      }}]

  describe "formatItemData", ->
    item1 = null
    item2 = null

    beforeEach ->
      item1 = BlogXmlParser.formatItemData(items[0])
      item2 = BlogXmlParser.formatItemData(items[1])

    it "returns the item title", ->
      expect(item1.title).toEqual("First Title")
      expect(item2.title).toEqual("Second Title")

    it "returns the item blogLink", ->
      expect(item1.blogLink).toEqual("some/link/here")
      expect(item2.blogLink).toEqual("some/link/here")

    it "returns the item imageSrc", ->
      expect(item1.imageSrc).toEqual("mockImages/img1.jpeg")
      expect(item2.imageSrc).toEqual("mockImages/img2.jpeg")

    it "returns the imageAlt", ->
      expect(item1.imageAlt).toEqual("Image1 title here")
      expect(item2.imageAlt).toEqual("Image2 title here")

    it "returns the authorLink", ->
      expect(item1.authorLink).toEqual("http://google.com/author1")
      expect(item2.authorLink).toEqual("http://google.com/author2")
