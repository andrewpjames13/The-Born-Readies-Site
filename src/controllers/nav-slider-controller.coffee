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
    # Class vars
    @threshold_hit = false

  ###
  *------------------------------------------*
  | onMousewheel:void (=)
  |
  | Mousewheelie.
  *----------------------------------------###
  onMousewheel: (e) =>
    e.preventDefault()

    if @threshold_hit is false
      d = (e.deltaY * e.deltaFactor)
      if Math.abs(d) >= 20
        @threshold_hit = true
        if d > 0
          @previousSlide()
        else if d < 0
          @nextSlide()

        setTimeout =>
          @threshold_hit = false
        , 666

  previousSlide: =>
    if TBR.active_page_index > 0
      console.log 'prev!', TBR.active_page_index - 1
      href = TBR.data.pages[TBR.active_page_index - 1].slug
      History.pushState(null, null, "/#{href}")

  nextSlide: =>
    if TBR.active_page_index < TBR.total_pages - 1
      console.log 'next!', TBR.active_page_index + 1
      href = TBR.data.pages[TBR.active_page_index + 1].slug
      History.pushState(null, null, "/#{href}")



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
      .off('mousewheel')
      .on('mousewheel', @onMousewheel)

  ###
  *------------------------------------------*
  | suspend:void (-)
  |
  | Activate.
  *----------------------------------------###
  suspend: ->
    # Turn off events
    @model.getE().off('mousewheel')

module.exports = NavSliderController
