define "jquery", -> $
define "ko", -> ko

require.config
  paths:
    "text": "../lib/text"

require \
  [
    "ko",
    "arrayFilter",
    "dummyService",
    "bindingHandler"
  ],
  (ko, arrayFilter, service) ->

    # items
    class ListItem
      constructor: (name = "", isSelected = false) ->
        @name = ko.observable name
        @isSelected = ko.observable isSelected

    # selectors
    isSelected = (i) -> i.isSelected()
    next = (item) ->
      found = false
      (i) ->
        if i is item
          found = true
        found
    previous = (item) ->
      found = true
      (i) ->
        if i is item
          found = false
        found

    model =
      loading: ko.observable false
      item: ko.observable(new ListItem)
      items: ko.observableArray([])
      query: (term) ->
        loading = true
        service.query(term).done (data) ->
          items =[]
          $.each data, (_, datum) ->
            items.push new ListItem datum
          loading = false
          model.items items
      select: (selected) ->
        model.item selected
      selectPrevious: ->
        items = model.items()

        if items.length
          selected = arrayFilter(isSelected).first items
          previous = arrayFilter(previous(selected)).last items

          if selected
            selected.isSelected false
          if previous
            previous.isSelected true
          if not previous
            items[items.length - 1].isSelected true

        model.items items
      selectNext: ->
        items = model.items()

        if items.length
          selected = arrayFilter(isSelected).first items
          previous = arrayFilter(next(selected)).first items

          if selected
            selected.isSelected false
          if previous
            previous.isSelected true
          if not previous
            items[0].isSelected true

        model.items items

    ko.applyBindings model