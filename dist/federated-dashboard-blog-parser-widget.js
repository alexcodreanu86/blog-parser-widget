(function(underscore) {
  'use strict';

  window.namespace = function(string, obj) {
    var current = window,
        names = string.split('.'),
        name;

    while((name = names.shift())) {
      current[name] = current[name] || {};
      current = current[name];
    }

    underscore.extend(current, obj);

  };

}(window._));

(function() {
  namespace("Blog");

  Blog.Controller = (function() {
    function Controller() {}

    Controller.widgets = [];

    Controller.getWidgets = function() {
      return this.widgets;
    };

    Controller.setupWidgetIn = function(settings) {
      var newWidget;
      newWidget = new Blog.Widgets.Controller(settings);
      newWidget.initialize();
      return this.addWidgetToContainer(newWidget);
    };

    Controller.addWidgetToContainer = function(newWidget) {
      return this.widgets.push(newWidget);
    };

    Controller.exitEditMode = function() {
      return this.allActiveWidgetsExecute('exitEditMode');
    };

    Controller.enterEditMode = function() {
      return this.allActiveWidgetsExecute('enterEditMode');
    };

    Controller.allActiveWidgetsExecute = function(command) {
      return _.each(this.widgets, (function(_this) {
        return function(widget) {
          if (widget.isActive()) {
            return widget[command]();
          }
        };
      })(this));
    };

    return Controller;

  })();

}).call(this);

(function() {
  namespace('Blog');

  Blog.Display = (function() {
    function Display() {}

    Display.generateLogo = function(settings) {
      return "<i class=\"fa fa-book " + settings["class"] + "\" data-id=\"" + settings.dataId + "\"></i>";
    };

    return Display;

  })();

}).call(this);

(function() {
  namespace('Blog.Widgets');

  Blog.Widgets.Api = (function() {
    function Api() {}

    Api.getBlogPosts = function(url, displayer) {
      var jsonData;
      jsonData = JSON.stringify({
        url: url
      });
      return $.post('/blog_feed', jsonData, function(response) {
        return displayer.showPosts(response);
      }, 'json');
    };

    return Api;

  })();

}).call(this);

(function() {
  namespace("Blog.Widgets");

  Blog.Widgets.Controller = (function() {
    function Controller(settings) {
      this.container = settings.container;
      this.defaultValue = settings.defaultValue;
      this.display = new Blog.Widgets.Display(settings.container, settings.numberOfPosts, settings.animationSpeed);
      this.refreshRate = settings.refreshRate;
      this.activeStatus = false;
    }

    Controller.prototype.getContainer = function() {
      return this.container;
    };

    Controller.prototype.initialize = function() {
      this.display.setupWidget();
      this.bind();
      this.setAsActive();
      return this.displayDefault();
    };

    Controller.prototype.bind = function() {
      $("" + this.container + " [data-id=blog-button]").click((function(_this) {
        return function() {
          return _this.processClickedButton();
        };
      })(this));
      return $("" + this.container + " [data-id=blog-close]").click((function(_this) {
        return function() {
          return _this.closeWidget();
        };
      })(this));
    };

    Controller.prototype.unbind = function() {
      $("" + this.container + " [data-id=blog-button]").unbind('click');
      return $("" + this.container + " [data-id=blog-close]").unbind('click');
    };

    Controller.prototype.closeWidget = function() {
      this.display.removeWidget();
      this.setAsInactive();
      return this.unbind();
    };

    Controller.prototype.processClickedButton = function() {
      var input;
      input = this.display.getInput();
      if (Blog.Widgets.Validator.isValidUrl(input)) {
        return this.getBlogPosts(input);
      }
    };

    Controller.prototype.getBlogPosts = function(input) {
      Blog.Widgets.Api.getBlogPosts(input, this.display);
      if (this.refreshRate) {
        this.clearCurrentTimeout();
        return this.refreshBlogPosts(input);
      }
    };

    Controller.prototype.clearCurrentTimeout = function() {
      if (this.timeout) {
        return clearTimeout(this.timeout);
      }
    };

    Controller.prototype.refreshBlogPosts = function(input) {
      return this.timeout = setTimeout((function(_this) {
        return function() {
          if (_this.isActive()) {
            return _this.getBlogPosts(input);
          }
        };
      })(this), this.refreshSeconds());
    };

    Controller.prototype.refreshSeconds = function() {
      return this.refreshRate * 1000;
    };

    Controller.prototype.displayDefault = function() {
      if (this.defaultValue) {
        return this.getBlogPosts(this.defaultValue);
      }
    };

    Controller.prototype.isActive = function() {
      return this.activeStatus;
    };

    Controller.prototype.setAsActive = function() {
      return this.activeStatus = true;
    };

    Controller.prototype.setAsInactive = function() {
      return this.activeStatus = false;
    };

    Controller.prototype.exitEditMode = function() {
      return this.display.exitEditMode();
    };

    Controller.prototype.enterEditMode = function() {
      return this.display.enterEditMode();
    };

    return Controller;

  })();

}).call(this);

(function() {
  namespace('Blog.Widgets');

  Blog.Widgets.Display = (function() {
    function Display(container, numberOfPosts, animationSpeed) {
      this.container = container;
      this.numberOfPosts = numberOfPosts;
      this.animationSpeed = animationSpeed;
    }

    Display.prototype.setupWidget = function() {
      var widgetHtml;
      widgetHtml = Blog.Widgets.Templates.renderForm();
      return $(this.container).append(widgetHtml);
    };

    Display.prototype.getInput = function() {
      return $("" + this.container + " [name=blog-search]").val();
    };

    Display.prototype.showPosts = function(posts) {
      var formatedPosts, postsHtml;
      formatedPosts = this.formatAllPosts(posts);
      postsHtml = Blog.Widgets.Templates.renderPosts(formatedPosts, this.numberOfPosts);
      return $("" + this.container + " [data-id=blog-output]").html(postsHtml);
    };

    Display.prototype.formatAllPosts = function(posts) {
      return _.map(posts, (function(_this) {
        return function(post) {
          return _this.formatPost(post);
        };
      })(this));
    };

    Display.prototype.formatPost = function(post) {
      var formatedPost;
      formatedPost = {};
      formatedPost.title = post.title;
      formatedPost.authorName = post.author;
      formatedPost.blogLink = post.link;
      formatedPost.imageSrc = post.image.url || "https://pbs.twimg.com/profile_images/1378895288/twitter-logo_400x400.png";
      formatedPost.imageAlt = post.image.title;
      formatedPost.authorLink = post.image.link;
      return formatedPost;
    };

    Display.prototype.removeWidget = function() {
      return $(this.container).remove();
    };

    Display.prototype.exitEditMode = function() {
      this.hideForm();
      return this.hideCloseWidgetButton();
    };

    Display.prototype.hideForm = function() {
      return $("" + this.container + " [data-id=blog-form]").hide(this.animationSpeed);
    };

    Display.prototype.hideCloseWidgetButton = function() {
      return $("" + this.container + " [data-id=blog-close]").hide(this.animationSpeed);
    };

    Display.prototype.enterEditMode = function() {
      this.showForm();
      return this.showCloseWidgetButton();
    };

    Display.prototype.showForm = function() {
      return $("" + this.container + " [data-id=blog-form]").show(this.animationSpeed);
    };

    Display.prototype.showCloseWidgetButton = function() {
      return $("" + this.container + " [data-id=blog-close]").show(this.animationSpeed);
    };

    return Display;

  })();

}).call(this);

(function() {
  namespace('Blog.Widgets');

  Blog.Widgets.Templates = (function() {
    function Templates() {}

    Templates.renderForm = function() {
      return _.template("<div class=\"widget\" data-id=\"blog-widget-wrapper\">\n  <div class=\"widget-header\">\n    <h2 class=\"widget-title\">Blog Posts</h2>\n    <span class='widget-close' data-id='blog-close'>×</span>\n      <div class=\"widget-form\" data-id=\"blog-form\">\n        <input name=\"blog-search\" type=\"text\" autofocus=\"true\">\n        <button id=\"blog\" data-id=\"blog-button\">Search blog</button><br>\n      </div>\n    </div>\n  <div class=\"widget-body\" data-id=\"blog-output\"></div>\n</div>");
    };

    Templates.renderPosts = function(posts, numberOfPosts) {
      if (numberOfPosts == null) {
        numberOfPosts = posts.length;
      }
      if (numberOfPosts > posts.length) {
        numberOfPosts = posts.length;
      }
      return _.template("<% for (var i = 0; i < numberOfPosts; i++){ %>\n  <div class=\"blog-post\">\n    <div class=\"blog-image-container\">\n      <img class=\"blog-image\" src=\"<%= posts[i].imageSrc %>\" alt=\"<%= posts[i].imageAlt %>\"/>\n    </div>\n    <div class=\"blog-information\">\n    <h3 class=\"blog-post-title\"><%= posts[i].title %></h3>\n    <p><a class=\"post-author-name\" href=\"<%= posts[i].authorLink %>\"><%= posts[i].authorName %></a></p>\n    </div>\n  </div>\n<% } %>", {
        posts: posts,
        numberOfPosts: numberOfPosts
      });
    };

    return Templates;

  })();

}).call(this);

(function() {
  namespace('Blog.Widgets');

  Blog.Widgets.Validator = (function() {
    function Validator() {}

    Validator.isValidUrl = function(url) {
      return new Boolean(this.matchUrl(url));
    };

    Validator.matchUrl = function(url) {
      return url.match(/http\:\/\/\w+\.\w+/);
    };

    return Validator;

  })();

}).call(this);

(function() {
  namespace('Blog.Widgets');

  Blog.Widgets.Validator = (function() {
    function Validator() {}

    Validator.isValidUrl = function(url) {
      return !!this.matchUrl(url);
    };

    Validator.matchUrl = function(url) {
      return url.match(/http\:\/\/\w+\.\w+/);
    };

    return Validator;

  })();

}).call(this);
