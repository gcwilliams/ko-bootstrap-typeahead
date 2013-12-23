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
  value: item().name, // the observable bound to the selected value
   dropdown: {
    suggestions: items, // the list of suggestions in the model
    query: query, // the function called to get more data
    select: select // the function called when an item is selected
  }"

```

Knockout model

```
var model = {
    loading: ko.observable(false), // true to show 'Loading...'
    item: ko.observable(""), // the selected item
    items: ko.observableArray([]), // the selections available
    query: function(term) { // the function called to get more data
      model.loading(true);
      service.query(term).then(function(data) {
        model.loading(false);
        model.items(data);
      });
    },
    select: function(selected) { // the function called when an item is selected
      model.items([]);
      model.item(selected);
    }
  };
```

See `example` folder for a page using the typeahead.

### Building

* Install [Node](http://nodejs.org/)
* Install grunt-cli `npm install -g grunt-cli`
* Install node modules `npm install`

To build a release version run `grunt` (creates a minified version which does not depend on requirejs).

### Developing

To develop run `grunt dev`, then `grunt watch` and `node server.js`. Grunt watches for changes and compiles, a host page will be available at `localhost:3030/host.html`.