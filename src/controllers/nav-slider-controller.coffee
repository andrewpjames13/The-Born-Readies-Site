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
    @$bottomBorder = $('.bottom-border', @model.getV())
    @$musicMenu = $('#music-menu', @model.getV())
    @$musicList = $('.menu-controls', @model.getV())
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
      href = TBR.data.pages[TBR.active_page_index - 1].slug
      History.pushState(null, null, "/#{href}")
      @$bottomBorder.animate { height: '1.5em' }, 800
      @$musicMenu.animate { bottom: '0' }, 800
      @$musicList.animate { bottom: '0' }, 800
      $('.footer-container').removeClass('open').addClass('closed')


  nextSlide: =>
    if TBR.active_page_index < TBR.total_pages - 1
      href = TBR.data.pages[TBR.active_page_index + 1].slug
      History.pushState(null, null, "/#{href}")
      if TBR.total_pages - 1 is TBR.active_page_index
        @$bottomBorder.animate { height: '3em' }, 800
        @$musicMenu.animate { bottom: '1.5em' }, 800
        @$musicList.animate { bottom: '.5' }, 800
        $('.footer-container').removeClass('closed').addClass('open')


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
