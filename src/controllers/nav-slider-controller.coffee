class NavSliderController

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

  ###
  *------------------------------------------*
  | setState:void (-)
  |
  | Set state.
  *----------------------------------------###
  slideTo: ->
    y = -(TBR.active_page_index * 100)
    @model.getE().css(TBR.utils.transform, TBR.utils.translate(0,"#{y}%"))

module.exports = NavSliderController
