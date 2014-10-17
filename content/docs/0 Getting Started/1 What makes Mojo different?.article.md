{{
  properties: {
    category: "getting started"
  }
}}

#### Property scope

Mojo views have the ability to inherit properties from their parent, all the way up to the root view. This feature is incredibly useful when you want to pass data from one view to another. A `user` model for instance might be used in other parts of your application. All you need to do is set the user model in the root view, and `get()` that property in any sub-view. This pattern is a great way of avoiding singletons, and makes your code far more interchangeable, and modular. 

Of course, you can be as implicit, or explicit as you want. Mojo also has the ability to break property scope simply by setting a property in any sub-view. 

Take a look at the [property scope docs](/docs/api/viewsbase#propertyscope) for more info.

<!--
show diagram here explaining property scope & models
-->


#### Compiled templates


Mojo templates (paperclip) are translated from HTML, straight to JavaScript - this also includes data-bindings. For example, here's a template:

```html
hello {{name}}!
```

Here's the templated translated to JavaScript:

```javascript
module.exports = (function(fragment, block, element, text, comment, parser, modifiers) {
  return fragment([text("hello "), block({
    'value': {
      run: function() {
          return this.context.name;
      },
      refs: [ ["name"] ]
    }
  })]);
});
```

Pretty clear what's going on. Here's what we know at a glance:

1. Generated DOM is identical to the HTML templates. No weird manipulations here.
2. Data-bindings are identified *as the template is created*. Note that this happens *once* for every template. Paperclip takes each translated template, caches them, and uses the browser's native `cloneNode()` whenever a template is used. 
3. JavaScript references within the templates are identified at translation time, and cached in the data-binding.

As it turns out, the method above for generating templates is very efficient. Essentially, paperclip does the least amount of work necessary to update the DOM since it know where everything is. 

Paperclip will also lazily batch DOM changes together into one update, and run them on requestAnimationFrame. This kind of optimization is similar to how layout engines work, and helps prevent
unnecessary performance penalties in the browser.

<!-- more info on parsed JS and bound helpers -->

<!--
- no explicit API calls
- virtual properties
-->

#### Virtual properties

Mojo uses [virtuals](/docs/api/modelsbase#virtuals) on models to asynchronously load remote resources as they're demanded in the application. They are essentially properties that only get defined when they're data-bound to. 

This has a number of sweet benefits:

1. Reduces the number of API calls.
2. Reduces the cognitive overhead of manually handling asynchronous resources.
3. Keeps your code DRY. No more calling `load()` anywhere outside of your models.
4. Allows for views to be used synchronously used on the backend.
5. Makes code more testable since virtuals can be overridden.
6. Makes code more maintainable if there's ever an API change - i.e: you might (and probably will) have a virtual property that's converted into a non-virtual property. 

<!--
#### Explicit data-bindings

Template data-bindings can be defined as [1-way, 2-way or even unbound](/docs/api/templates#bindingoperators). 
-->

#### Explicit

Mojo was designed around explicity, and simplicity. What you write is what you should expect out of the framework. There are no gotchyas, no magic (If there is, then tell us about it!), everything was designed to work in a coherent way. 

Data-bindings are even explicit. You can easily define [1-way, 2-way, or even unbound references](/docs/api/templates#bindingoperators) within templates.


<!--
#### Architecture

Mojo isn't just a tool, or library, it's a set of libraries that work very well together. We understand that 
-->

<!--
#### Flexibility

-->




<!--
show diagram?
-->


<!--
relationships
data bindings
-->


<!--


#### Organization

#### minimal API

Mojo was reduced to the API's essential for application development. We don't want to provide unnecessary features that won't get used, or make you wonder what it does. 

#### Organization

Mojo application s

Intuitiveness

http://stackoverflow.com/questions/731743/php-vs-template-engine

### Explicit & Implicitness

data bindings
property scope
router + views

### Gotchyas

Very few


### Architecture

modules were designed 
well thought out, minimal API's. Doesn't do what it doesn't need to do.

### Developer workflow

-->

<!--
Developer workflow
-->

