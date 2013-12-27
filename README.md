  # Knockout / Bootstrap TypeAhead

A simple knockout type-ahead using bootstrap 3.


### Dependencies

* [jQuery](https://github.com/jquery/jquery)
* [KnockoutJs](https://github.com/knockout/knockout)
* [Bootstrap](https://github.com/twbs/bootstrap)

### Usage

Knockout binding

```
data-bind="
   dropdown: {
    suggestion: suggestion, // the observable bound to the selected value
    query: query // the function called to get more data
  }"

```

Knockout model

```
var model = {
  loading: ko.observable(false), // true to show 'Loading...'
  suggestion: ko.observable(""), // the selected suggestion
  suggestions: ko.observableArray([]), // the selections available
  query: function(term) { // the function called to get more data
    model.loading(true);
    service.query(term).then(function(data) {
      model.loading(false);
      model.suggestions(data);
    });
  },
};

mode.suggestion.subscribe(function() { // the function called when a suggestion is selected to clear the suggestions
  model.suggestions([]);
})
```

See `example` folder for a page using the typeahead.

### Building

* Install [Node](http://nodejs.org/)
* Install grunt-cli `npm install -g grunt-cli`
* Install node modules `npm install`

To build a release version run `grunt` (creates a minified version which does not depend on requirejs).

### Developing

To develop run `grunt dev`, then `grunt watch` and `node server.js`. Grunt watches for changes and compiles, a host page will be available at `localhost:3030/host.html`.