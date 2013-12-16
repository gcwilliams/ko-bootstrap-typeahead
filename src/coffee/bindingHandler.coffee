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

        $(element).on "click", ->
          if not open
            openTypeAhead()


        throttleTimeout = null;

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
            when constants.Keys.ESC
              if open
                disposer()
            else
              if not open
                openTypeAhead()
              clearTimeout throttleTimeout
              throttleTimeout = setTimeout (-> config.query($(element).val())), 500

        $menu = $("#menu", $parent)

        $menu.on "click", (e) ->
          e.preventDefault()
          e.stopPropagation()
          config.select ko.dataFor e.toElement
          disposer()

        $menu.on "mouseover", (e) ->
          e.preventDefault()
          data = ko.dataFor e.toElement
          console.log data
          if data isnt bindingContext.$data
            config.hover data

      update: (element, valueAccessor, allBindings, viewModel, bindingContext) ->