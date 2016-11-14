class YouAreHereController

  ###
  *------------------------------------------*
  | constructor:void (-)
  |
  | init:object - init object
  |
  | Construct.
  *----------------------------------------###
  constructor: (init) ->
    @model = init.model
    @build()

  ###
  *------------------------------------------*
  | build:void (-)
  |
  | Build.
  *----------------------------------------###
  build: ->
    @model.setV($(JST["you-are-here-view"]()))
    @model.getE().append(@model.getV())

    #Class vars
    @$nav_item = $('li', @model.getE())

    # Observe
    @observeSomeSweetEvents()

  ###
  *------------------------------------------*
  | observeSomeSweetEvents:void (-)
  |
  | Observe some sweet events.
  *----------------------------------------###
  observeSomeSweetEvents: ->
    @$nav_item.on('click', @onClickNavItem)

  ###
  *------------------------------------------*
  | onClickNavItem:void (=)
  |
  | Click nav item, hide then update router
  *----------------------------------------###
  onClickNavItem: (e) =>
    $t = $(e.currentTarget)
    id = if $t.attr('data-id') is 'home' then '' else $t.attr('data-id')

    History.pushState(null, null, "/#{id}")

    @$nav_item.removeClass('active')
    $t.addClass('active')

    if $t[0].innerHTML == 'Contact'
      $('.footer-container').addClass('open')
      $('.bottom-border').animate { height: '3em' }, 800
      $('#music-menu').animate { bottom: '2em' }, 800
      $('.menu-controls').animate { bottom: '.5' }, 800
    else
      $('#about, #merch').removeClass('detail-mode')
      $('.footer-container').removeClass('open')
      $('.bottom-border').animate { height: '1em' }, 800
      $('#music-menu').animate { bottom: '0' }, 800
      $('.menu-controls').animate { bottom: '0' }, 800

    if $('#music-menu').hasClass('home')
      $('#music-menu').removeClass('home')

module.exports = YouAreHereController
