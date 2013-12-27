define "jquery", -> $
define "ko", -> ko

require \
  [
    "ko",
    "dummyService",
    "bindingHandler"
  ],
  (ko, service) ->

    model =
      loading: ko.observable false
      suggestion: ko.observable {}
      suggestions: ko.observableArray []
      query: (term) ->
        model.loading true
        service.query(term).done (data) ->
          model.loading false
          model.suggestions data

    model.suggestion.subscribe ->
      model.suggestions []

    ko.applyBindings model