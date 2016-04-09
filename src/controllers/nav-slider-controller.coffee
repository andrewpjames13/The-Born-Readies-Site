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
  | onMousewheel:void (=)
  |
  | Mousewheelie.
  *----------------------------------------###
  onMousewheel: (e) =>
    e.preventDefault()

    if TBR.threshold_hit is false
      d = (e.deltaY * e.deltaFactor)
      if Math.abs(d) >= 20
        TBR.threshold_hit = true
        if d > 0
          @previousSlide()
        else if d < 0
          @nextSlide()

        setTimeout =>
          TBR.threshold_hit = false
        , 666

  previousSlide: =>
    if TBR.active_page_index > 0
      console.log 'PREV'
      href = TBR.data.pages[TBR.active_page_index - 1].slug
      History.pushState(null, null, "/#{href}")
      TBR.$body.trigger('footer_collapse')


  nextSlide: =>
    if TBR.active_page_index < TBR.total_pages - 1
      console.log 'NEXT'
      href = TBR.data.pages[TBR.active_page_index + 1].slug
      History.pushState(null, null, "/#{href}")
      if TBR.total_pages - 1 is TBR.active_page_index
        TBR.$body.trigger('footer_expand')


  ###
  *------------------------------------------*
  | setState:void (-)
  |
  | Set state.
  *----------------------------------------###
  slideTo: ->
    y = -(TBR.active_page_index * 100)
    @model.getE().css(TBR.utils.transform, TBR.utils.translate(0,"#{y}%"))

  ###
  *------------------------------------------*
  | activate:void (-)
  |
  | Activate.
  *----------------------------------------###
  activate: ->
    # Turn on events
    @model.getE()
      .off('mousewheel.nav')
      .on('mousewheel.nav', @onMousewheel)

  ###
  *------------------------------------------*
  | suspend:void (-)
  |
  | Activate.
  *----------------------------------------###
  suspend: ->
    # Turn off events
    @model.getE().off('mousewheel.nav')

module.exports = NavSliderController
