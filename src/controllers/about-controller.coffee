class AboutController

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
    @$lightening = $('#lightening', @model.getV())

    # Observe
    @observeSomeSweetEvents()

  observeSomeSweetEvents: ->
    @$lightening.on("click", @moveItOnOver)

  moveItOnOver: =>
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

  ###
  *------------------------------------------*
  | suspend_detail:void (-)
  |
  | Suspend detail.
  *----------------------------------------###
  suspend_detail: ->
    @$detail.removeClass('active')

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

module.exports = AboutController
