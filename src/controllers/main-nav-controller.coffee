class MainNavController

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
    @model.setV($(JST["main-nav-view"]()))
    @model.getE().append(@model.getV())

    #Class vars
    @$nav_item = $('li span', @model.getE())

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

    @hideNav()
    @model.getE()
      .off(TBR.utils.transition_end)
      .one(TBR.utils.transition_end, =>
        History.pushState(null, null, "/#{id}")
      )
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

  toggleNav: =>
    if @model.getE().hasClass('show') is false
      @showNav()
    else
      @hideNav()

  showNav: =>
    @model.getE().addClass('show')
    $('#nav-button').addClass('open')

  hideNav: =>
    @model.getE().removeClass('show')
    $('#nav-button').removeClass('open')

module.exports = MainNavController
