class MerchController

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
    @id = @model.getId()

    @build()

  ###
  *------------------------------------------*
  | build:void (-)
  |
  | Build.
  *----------------------------------------###
  build: ->
    @model.setV($(JST["#{@id}-view"](_.findWhere(TBR.data.pages, {"id": @id}))))
    @model.getE().append(@model.getV())

    # Class vars
    @$detail = $('.detail', @model.getV())
    @$button = $('#button', @model.getV())
    @observeSomeSweetEvents()

  observeSomeSweetEvents: ->
    @$button.on("click", @moveItOnOver)

  moveItOnOver: =>
    # $('.detail > section').css(TBR.utils.transform, TBR.utils.translate(0, "0%"))
    href = TBR.data.pages[TBR.active_page_index].detail.slug
    History.pushState(null, null, "/#{href}")

  ###
  *------------------------------------------*
  | activate_detail:void (-)
  |
  | Activate detail.
  *----------------------------------------###
  activate_detail: ->
    @$detail.addClass('active')
    $('#record').css(transform: 'rotate(-390deg)')
    $('.title').css(transform: 'translate(0%,-21%)', opacity: 1)
    @model.getE().addClass('detail-mode')


  ###
  *------------------------------------------*
  | suspend_detail:void (-)
  |
  | Suspend detail.
  *----------------------------------------###
  suspend_detail: ->
    @$detail.removeClass('active')
    $('#record').css(transform: 'rotate(0deg)')
    $('.title').css(transform: 'translate(0%,50%)', opacity: 0)
    @model.getE().removeClass('detail-mode')

  ###
  *------------------------------------------*
  | activate:void (-)
  |
  | Activate.
  *----------------------------------------###
  activate: ->
    @model.getE().addClass('active')

  ###
  *------------------------------------------*
  | suspend:void (-)
  |
  | Activate.
  *----------------------------------------###
  suspend: ->
    @model.getE().removeClass('active')

module.exports = MerchController
