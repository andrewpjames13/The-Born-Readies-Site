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


  toggleNav: =>
    if @model.getE().hasClass('show') is false
      @showNav()
    else
      @hideNav()

  showNav: =>
    @model.getE().addClass('show')

  hideNav: =>
    @model.getE().removeClass('show')

module.exports = MainNavController
