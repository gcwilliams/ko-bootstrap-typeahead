$(function() {

  "use strict";

  var service, model;

  // a dummy service used in the example
  service = (function() {
    function Item(name) {
      this.name = name;
    }

    function query(term) {

      return $.Deferred(function(deferred) {

        var data = [
          new Item("One"),
          new Item("Two"),
          new Item("Three"),
          new Item("Four"),
          new Item("Five"),
          new Item("Six")
        ];

        setTimeout(function() {
          deferred.resolve(data.filter(function(item) {
            return !!~item.name.indexOf(term);
          }));
        }, Math.random() * 250);
      });
    }

    return {
      query: query
    };
  })();

  model = {
    loading: ko.observable(false), // true to show 'Loading...'
    suggestion: ko.observable(""), // the selected suggestion
    suggestions: ko.observableArray([]), // the selections available
    query: function(term) { // called to query for the data and to update the suggestions
      model.loading(true);
      service.query(term).then(function(data) {
        model.loading(false);
        model.suggestions(data);
      });
    },
    select: function(selected) { // called when an suggestion is selected
      model.suggestions([]);
      model.suggestion(selected);
    }
  };

  ko.applyBindings(model);
});