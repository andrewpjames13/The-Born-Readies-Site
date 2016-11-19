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

    if TBR.active_page_index >= 0
      TBR.$body.trigger('footer_collapse')
      $('#music-menu').addClass('home')

    if TBR.total_pages - 1 is TBR.active_page_index
      TBR.$body.trigger('footer_expand')

    if TBR.active_page_index > 0
      $('#music-menu').removeClass('home')

module.exports = YouAreHereController
