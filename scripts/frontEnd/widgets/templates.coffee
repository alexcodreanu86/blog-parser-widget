namespace('Blog.Widgets')

class Blog.Widgets.Templates
  @renderForm: ->
    _.template("""
      <div class="widget" data-id="blog-widget-wrapper">
        <div class="widget-header">
          <h2 class="widget-title">Blog Posts</h2>
          <span class='widget-close' data-id='blog-close'>×</span>
            <div class="widget-form" data-id="blog-form">
              <input name="blog-search" type="text" autofocus="true">
              <button id="blog" data-id="blog-button">Search blog</button><br>
            </div>
          </div>
        <div class="widget-body" data-id="blog-output"></div>
      </div>
    """)

  @renderPosts: (posts) ->
    _.template("""
    <% for (var i = 0; i < posts.length; i++){ %>
      <div class="blog-post">
        <div class="blog-image-container">
          <img class="blog-image" src="<%= posts[i].imageSrc %>" alt="<%= posts[i].imageAlt %>" style="height: 75px;" />
        </div>
        <div class="blog-information">
        <h3 class="blog-post-title"><%= posts[i].title %></h3>
        <p><a class="post-author-name" href="<%= posts[i].authorLink %>"><%= posts[i].authorName %></a></p>
        </div>
      </div>
    <% } %>
    """, {posts: posts})
