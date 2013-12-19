define "jquery", -> $
define "ko", -> ko

require.config
  paths:
    "text": "../lib/text"

require \
  [
    "ko",
    "dummyService",
    "bindingHandler"
  ],
  (ko, service) ->

    model =
      loading: ko.observable false
      item: ko.observable {}
      items: ko.observableArray []
      query: (term) ->
        model.loading true
        service.query(term).done (data) ->
          model.loading false
          model.items data
      select: (selected) ->
        model.items []
        model.item selected

    ko.applyBindings model