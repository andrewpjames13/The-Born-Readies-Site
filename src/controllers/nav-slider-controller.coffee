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
    # Draggable vars
    @dragging = false
    @drag_time = 512
    @start_time = 0
    @start_y = 0
    @current_y = 0
    @direction_y = 0
    @current_range_y = 0
    @now = 0
    @trans_y = 0
    @swiped = false

  ###
  *------------------------------------------*
  | onTouchstart:void (=)
  |
  | Touch start.
  *----------------------------------------###
  onTouchstart: (e) =>
    if e.which is 1 or TBR.utils.is_mobile.any()
      @dragging = true
      @start_time = (new Date()).getTime()
      @start_y = if Modernizr.touch then e.originalEvent.targetTouches[0].pageY else e.pageY

      TBR.$doc
        .off('mouseup.nav touchend.nav')
        .one('mouseup.nav touchend.nav', @onTouchend)

  ###
  *------------------------------------------*
  | onTouchmove:void (=)
  |
  | Touch move.
  *----------------------------------------###
  onTouchmove: (e) =>
    if @dragging is true
      e.preventDefault()

      @current_y = if Modernizr.touch then e.originalEvent.targetTouches[0].pageY else e.pageY
      @direction_y = @current_y - @start_y
      @current_range_y = if @start_y is 0 then 0 else Math.abs(@direction_y)
      @now = (new Date()).getTime()
      resistance = if (@direction_y >= 0 and TBR.active_page_index is 0) or (@direction_y <= 0 and TBR.active_page_index is (TBR.total_pages - 1)) then 4 else 1
      drag_y = ((@trans_y / 100) * @model.getE().height() + (@direction_y / resistance))

      @model.getE()
        .addClass('dragging')
        .css(TBR.utils.transform, TBR.utils.translate(0, "#{drag_y}px"))

      return false

  ###
  *------------------------------------------*
  | onTouchend:void (=)
  |
  | Touch end.
  *----------------------------------------###
  onTouchend: (e)=>
    if @model.getE().hasClass('dragging')
      @model.getE().removeClass('dragging')

      if (@now - @start_time < @drag_time and @current_range_y > (@model.getE().height() / 8)) or @current_range_y > (@model.getE().height() / 2)
        @swiped = true
        if @current_y > @start_y
          @previousSlide()
        if @current_y < @start_y
          @nextSlide()
      else
        @slideTo()

      @dragging = false
      @swiped = false
      return false

    else
      @dragging = false
      @swiped = false

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
      if Math.abs(d) >= 60
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
      href = TBR.data.pages[TBR.active_page_index - 1].slug
      History.pushState(null, null, "/#{href}")
      TBR.$body.trigger('footer_collapse')
    else
      @slideTo()


  nextSlide: =>
    if TBR.active_page_index < TBR.total_pages - 1
      $('#music-menu').removeClass('home')
      href = TBR.data.pages[TBR.active_page_index + 1].slug
      History.pushState(null, null, "/#{href}")
      if TBR.total_pages - 1 is TBR.active_page_index
        TBR.$body.trigger('footer_expand')
    else
      @slideTo()


  ###
  *------------------------------------------*
  | setState:void (-)
  |
  | Set state.
  *----------------------------------------###
  slideTo: ->
    @trans_y = -(TBR.active_page_index * 100)
    if @swiped is true
      @model.getE().addClass('swiped')

    @model.getE()
      .css(TBR.utils.transform, TBR.utils.translate(0,"#{@trans_y}%"))
      .off(TBR.utils.transition_end)
      .one(TBR.utils.transition_end, =>
        @model.getE()[0].offsetHeight
        @model.getE().removeClass('dragging swiped')
      )

  ###
  *------------------------------------------*
  | activate:void (-)
  |
  | Activate.
  *----------------------------------------###
  activate: ->
    # Turn on events
    @model.getE()
      .off('mousewheel.nav mousedown.nav touchstart.nav mousemove.nav touchmove.nav')
      .on('mousewheel.nav', @onMousewheel)
      .on('mousedown.nav touchstart.nav', @onTouchstart)
      .on('mousemove.nav touchmove.nav', @onTouchmove)

  ###
  *------------------------------------------*
  | suspend:void (-)
  |
  | Activate.
  *----------------------------------------###
  suspend: ->
    # Turn off events
    @model.getE().off('mousewheel.nav mousedown.nav touchstart.nav mousemove.nav touchmove.nav')

module.exports = NavSliderController
