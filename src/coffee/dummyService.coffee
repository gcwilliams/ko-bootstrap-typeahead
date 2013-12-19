define [], ->
  
  class ArrayFilter
    constructor: ->
        predicates = Array.prototype.slice.call arguments, 0
        @predicates = (x) -> predicates.every (p) -> p x

    first: (array) ->
        filtered = array.filter @predicates
        if filtered.length then filtered[0] else null

    last: (array) ->
        filtered = array.filter @predicates
        if filtered.length then filtered[filtered.length - 1] else null

    all: (array) ->
        array.filter @predicates

  arrayFilter =  (predicates) -> new ArrayFilter predicates

  startsWith = (term) ->
    matcher = new RegExp "^#{term}", "i"
    (l) -> matcher.test l

  class Result
    constructor: (@name) ->

  service =
    query: (term) ->
      $.Deferred (def) ->
        results = ->
          results = arrayFilter(startsWith(term)).all ["Los Angeles", "Las Vegas", "New York", "Orlando", "Miami"]
          def.resolve results.map (r) -> new Result r
        setTimeout results, Math.floor Math.random() * 1000
    