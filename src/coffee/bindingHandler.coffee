define \
  [
    "jquery",
    "ko",
    "closeHandler",
    "text!../templates/dropdown.html",
    "constants"
  ], ($, ko, closeHandler, template, constants) ->

    ko.bindingHandlers.dropdown =

      init: (element, valueAccessor, allBindings, viewModel, bindingContext) ->

        config = valueAccessor()

        open = false;
        disposer = ->

        $parent = $(element).parent()
        $parent.append $(template)

        openTypeAhead = ->
          open = true

          $dropdown = $(".dropdown", $parent)
          $dropdown.addClass "open"

          disposer = closeHandler.create $parent.get(0), ->
            $dropdown.removeClass "open"
            open = false

          config.query($(element).val())

        $(element).on "focus", ->
          if not open
            openTypeAhead()

        $(element).on "keyup", (e) ->
          e.preventDefault()
          e.stopPropagation()
          
          switch e.keyCode
            when constants.Keys.UP
              if open 
                config.previous()
            when constants.Keys.DOWN
              if open
                config.next()
              else
                openTypeAhead()
            when constants.Keys.ENTER, constants.Keys.TAB
              if open
                $selected = $("a.selected", $parent)
                if $selected.length
                  config.select ko.dataFor $selected.get 0
                  disposer()
            else
              if open
                config.query($(element).val())
              else
                openTypeAhead()

        $(".dropdown-menu", $parent).on "click", (e) ->
          e.preventDefault()
          e.stopPropagation()
          config.select ko.dataFor e.toElement
          disposer()

      update: (element, valueAccessor, allBindings, viewModel, bindingContext) ->