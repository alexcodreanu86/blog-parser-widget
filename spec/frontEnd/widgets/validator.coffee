describe "Blog.Widgets.UrlValidator", ->
  describe "isValidUrl", ->
    it "returns true when the url is valid", ->
      url = "http://someurlhere.com/somethingelse/atom.xml"
      expect(Blog.Widgets.Validator.isValidUrl(url)).toEqual(true)

    it "returns false for url with no http heading", ->
      url = "someurlhere.com/somethingelse/atom.xml"
      expect(Blog.Widgets.Validator.isValidUrl(url)).toEqual(false)

    it "returns false for url with no domain", ->
      url = "http://someu/rlhere.com/somethingelse/atom.xml"
      expect(Blog.Widgets.Validator.isValidUrl(url)).toEqual(false)

    it "returns true for a namespaced url", ->
      url = "http://someurlhere.somewhereelse.com/somethingelse/atom.xml"
      expect(Blog.Widgets.Validator.isValidUrl(url)).toEqual(true)
