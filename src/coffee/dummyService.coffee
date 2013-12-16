define ["arrayFilter"], (arrayFilter) ->

  startsWith = (term) ->
    matcher = new RegExp "^#{term}", "i"
    (l) -> matcher.test l

  service =
    query: (term) ->
      $.Deferred (def) ->
        results = ->
          results = arrayFilter(startsWith(term)).all ["Los Angeles", "Las Vegas", "New York", "Orlando", "Miami"]
          def.resolve results
        setTimeout results, Math.floor Math.random() * 1000
    