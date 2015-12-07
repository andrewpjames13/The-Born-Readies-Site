class HeaderController

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
    @model.setV($(JST['header-view'](DEMO.data)))
    @model.getE().append(@model.getV())

    @$nav_item = $('a.ajaxy', @model.getV())

  ###
  *------------------------------------------*
  | setState:void (-)
  |
  | Set state.
  *----------------------------------------###
  setState: (state) ->
    @$nav_item.removeClass('active').filter('[data-id="' + state + '"]').addClass('active')

module.exports = HeaderController