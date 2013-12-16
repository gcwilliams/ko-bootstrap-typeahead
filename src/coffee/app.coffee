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
          false
        else
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
        model.loading true
        model.items []
        service.query(term).done (data) ->
          items =[]
          $.each data, (_, datum) ->
            items.push new ListItem datum
          model.loading false
          model.items items
      select: (selected) ->
        model.item selected
      selectPrevious: ->
        items = model.items()

        if items.length
          selectedItem = arrayFilter(isSelected).first items
          previousItem = arrayFilter(previous(selectedItem)).last items

          if selectedItem
            selectedItem.isSelected false
          if previousItem
            previousItem.isSelected true
          if not previousItem
            items[items.length - 1].isSelected true

        model.items items
      selectNext: ->
        items = model.items()

        if items.length
          selectedItem = arrayFilter(isSelected).first items
          nextItem = arrayFilter(next(selectedItem)).first items

          if selectedItem
            selectedItem.isSelected false
          if nextItem
            nextItem.isSelected true
          if not nextItem
            items[0].isSelected true

        model.items items

      hover: (item) ->
        items = model.items()

        if items.length
          selectedItem = arrayFilter(isSelected).first items
          if selectedItem
            selectedItem.isSelected false
          item.isSelected true
          console.log item.name()

        model.items items

    ko.applyBindings model