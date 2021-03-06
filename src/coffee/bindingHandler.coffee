define "jquery", -> $
define "ko", -> ko

define \
  [
    "jquery",
    "ko",
    "closeHandler",
    "../lib/text!../templates/dropdown.html",
    "constants"
  ], ($, ko, closeHandler, template, constants) ->

    ko.bindingHandlers.dropdown =

      init: (element, valueAccessor, allBindings, viewModel, bindingContext) ->

        config = valueAccessor()

        open = false

        throttleTimeout = null

        disposer = ->

        openTypeAhead = ->
          open = true

          config.suggestion ""

          $dropdown = $(".dropdown", $parent)
          $dropdown.addClass "open"

          disposer = closeHandler.create $parent.get(0), ->
            $dropdown.removeClass "open"
            open = false

          config.query $(element).val()

        onFocus = ->
          if not open
            openTypeAhead()

        onClick = ->
          if not open
            openTypeAhead()

        cancelEvent = (e) ->
          e.preventDefault()
          e.stopPropagation()

        onKeyPress = (e) ->
          switch e.keyCode
            when constants.Keys.ENTER
              e.preventDefault()

        onKeyDown = (e) ->
          switch e.keyCode
            when constants.Keys.ENTER
              e.preventDefault()

        onKeyUp = (e) ->
          cancelEvent e
          switch e.keyCode
            when constants.Keys.UP
              if open 
                $selected = $ "li.selected", $parent
                if $selected.length
                  $selected.removeClass("selected").prev("li").addClass("selected")
                else
                  $("li", $parent).last().addClass "selected"
            when constants.Keys.DOWN
              if open
                $selected = $ "li.selected", $parent
                if $selected.length
                  $selected.removeClass("selected").next("li").addClass("selected")
                else
                  $("li", $parent).first().addClass "selected"
              else
                openTypeAhead()
            when constants.Keys.ENTER
              if open
                $selected = $ "li.selected > a", $parent
                if $selected.length
                  data = ko.dataFor $selected.get 0
                  config.suggestion data
                  $el.val data.name
                  disposer()
            when constants.Keys.ESC
              if open
                disposer()
            else
              if not open
                openTypeAhead()
              clearTimeout throttleTimeout
              throttleTimeout = setTimeout (-> config.query $(element).val()), 200

        onClickItem = (e) ->
          cancelEvent e
          data = ko.dataFor e.toElement
          $el.val data.name
          config.suggestion data
          disposer()

        onMouseOverItem = (e) ->
          cancelEvent e
          data = ko.dataFor e.toElement
          if data isnt bindingContext.$data
            $("li", $parent).removeClass "selected"
            $(e.toElement).parent().addClass "selected"

        onChange = (e) ->
          selected = config.suggestion()
          config.suggestion $el.val() if not selected

        # cache element and parent
        $el = $ element
        $parent = $el.parent()
        $parent.append $ template
        $menu = $ "#menu", $parent

        # hook up events
        $el.bind "focus", onFocus
        $el.bind "click", onClick
        $el.bind "keyup", onKeyUp
        $el.bind "keypress", onKeyPress
        $el.bind "keydown", onKeyDown
        $el.bind "change", onChange
        $menu.bind "click", onClickItem
        $menu.bind "mouseover", onMouseOverItem

        # hook up disposal
        ko.utils.domNodeDisposal.addDisposeCallback element, ->
          $el.unbind onFocus
          $el.unbind onClick
          $el.unbind onKeyUp
          $el.unbind onKeyPress
          $el.unbind onKeyDown
          $el.unbind onChange
          $menu.unbind onClickItem
          $menu.unbind onMouseOverItem

      update: (element, valueAccessor, allBindings, viewModel, bindingContext) ->