namespace('Blog.Widgets')

class Blog.Widgets.Display
  constructor: (container, numberOfPosts, animationSpeed) ->
    @container = container
    @numberOfPosts = numberOfPosts
    @animationSpeed = animationSpeed

  setupWidget: ->
    widgetHtml = Blog.Widgets.Templates.renderForm()
    $(@container).append(widgetHtml)

  getInput: ->
    $("#{@container} [name=blog-search]").val()

  showPosts: (posts) ->
    formatedPosts =  @formatAllPosts(posts)
    postsHtml = Blog.Widgets.Templates.renderPosts(formatedPosts, @numberOfPosts)
    $("#{@container} [data-id=blog-output]").html(postsHtml)

  formatAllPosts: (posts) ->
    _.map(posts, (post) =>
      @formatPost(post)
    )

  formatPost: (post) ->
    formatedPost            = {}
    formatedPost.title      = post.title
    formatedPost.authorName = post.author
    formatedPost.blogLink   = post.link
    formatedPost.imageSrc   = post.image.url || "https://pbs.twimg.com/profile_images/1378895288/twitter-logo_400x400.png"
    formatedPost.imageAlt   = post.image.title
    formatedPost

  removeWidget: ->
    $(@container).remove()

  exitEditMode: ->
    @hideForm()
    @hideCloseWidgetButton()

  hideForm: ->
    $("#{@container} [data-id=blog-form]").hide(@animationSpeed)

  hideCloseWidgetButton: ->
    $("#{@container} [data-id=blog-close]").hide(@animationSpeed)

  enterEditMode: ->
    @showForm()
    @showCloseWidgetButton()

  showForm: ->
    $("#{@container} [data-id=blog-form]").show(@animationSpeed)

  showCloseWidgetButton: ->
    $("#{@container} [data-id=blog-close]").show(@animationSpeed)
