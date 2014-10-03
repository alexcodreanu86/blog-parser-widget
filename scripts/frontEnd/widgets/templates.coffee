namespace('Blog.Widgets')

class Blog.Widgets.Templates
  @renderForm: ->
    _.template("""
                  <div class='widget' data-name='widget-wrapper'>
                    <div class='widget-header' data-name='sortable-handle'>
                      <h2 class="widget-title">Blog Posts</h2>
                      <span class='widget-close' data-name='widget-close'>×</span>
                      <form class='widget-form' data-name='widget-form'>
                        <input name='widget-input' type='text' autofocus='true'>
                        <button data-name="form-button">Search Blog</button><br>
                      </form>
                    </div>
                    <div class="widget-body" data-name="widget-output"></div>
                  </div>
                """, {})
  @renderPosts: (posts, numberOfPosts = posts.length) ->
    if numberOfPosts > posts.length
      numberOfPosts = posts.length
    _.template("""
    <% for (var i = 0; i < numberOfPosts; i++){ %>
      <div class="blog-post">
        <div class="blog-image-container">
          <img class="blog-image" src="<%= posts[i].imageSrc %>" alt="<%= posts[i].imageAlt %>"/>
        </div>
        <div class="blog-information">
        <h3 class="blog-post-title"><%= posts[i].title %></h3>
        <p><a class="post-author-name" href="<%= posts[i].blogLink %>"><%= posts[i].authorName %></a></p>
        </div>
      </div>
    <% } %>
    """, {posts: posts, numberOfPosts: numberOfPosts})
