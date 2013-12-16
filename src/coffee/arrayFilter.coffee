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

    (predicates) -> new ArrayFilter predicates