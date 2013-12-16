define ["arrayFilter"], (arrayFilter) ->

  startsWith = (term) ->
    matcher = new RegExp "^#{term}", "i"
    (l) -> matcher.test l

  service =
    query: (term) ->
      $.Deferred (def) ->
        results = arrayFilter(startsWith(term)).all ["One", "Two", "Three"]
        def.resolve results
    