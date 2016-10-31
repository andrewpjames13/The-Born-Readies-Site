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
    @$button = $('button', @model.getV())
    @$detail_slider = $('.detail-slider', @model.getV())
    @$section = $('section', @model.getV())
    @$black_shirt = $('#shirt-black', @model.getV())
    @$white_shirt = $('#shirt-white', @model.getV())
    @$black_shirt_swatch = $('#black-hover', @model.getV())
    @$white_shirt_swatch = $('#white-hover', @model.getV())

    @sectionCount = 0
    @activeSectionIndex = 0
    @in_detail = false
    @totalSections = @$section.length

    # Draggable vars
    @dragging = false
    @drag_time = 512
    @start_time = 0
    @start_y = 0
    @current_y = 0
    @direction_y = 0
    @current_range_y = 0
    @now = 0
    
    @observeSomeSweetEvents()

  observeSomeSweetEvents: ->
    @$button.on("click", @moveItOnOver)
    @$black_shirt_swatch.on('click mouseenter', @changeShirts)
    @$white_shirt_swatch.on('click mouseenter', @changeShirts)

  moveItOnOver: =>
    href = TBR.data.pages[TBR.active_page_index].detail.slug
    History.pushState(null, null, "/#{href}")
    TBR.$body.trigger('footer_collapse')

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
      # resistance = if (@direction_y >= 0 and TBR.active_page_index is 0) or (@direction_y <= 0 and TBR.active_page_index is (TBR.total_pages - 1)) then 4 else 1
      # drag_y = ((@trans_y / 100) * @model.getE().height() + (@direction_y / resistance))

      @model.getE()
        .addClass('dragging')
        # .css(TBR.utils.transform, TBR.utils.translate(0, "#{drag_y}px"))

      return false

  ###
  *------------------------------------------*
  | onTouchend:void (=)
  |
  | Touch end.
  *----------------------------------------###
  onTouchend: (e)=>
    @dragging = false
    if @model.getE().hasClass('dragging')
      @model.getE().removeClass('dragging')

      if (@now - @start_time < @drag_time and @current_range_y > (@model.getE().height() / 8)) or @current_range_y > (@model.getE().height() / 2)
        # @swiped = true
        if @current_y > @start_y
          @previousSection()
        if @current_y < @start_y
          @nextSection()
      # else
      #   @slideTo()

      # @swiped = false
      return false

    # else
    #   @dragging = false
      # @swiped = false

  ###
  *------------------------------------------*
  | onMousewheel:void (=)
  |
  | Mousewheelie.
  *----------------------------------------###
  onMousewheel: (e) =>
    if @in_detail is true
      e.preventDefault()

      if TBR.threshold_hit is false
        d = (e.deltaY * e.deltaFactor)
        if Math.abs(d) >= 20
          TBR.threshold_hit = true
          if d > 0
            @previousSection()
          else if d < 0
            @nextSection()
          setTimeout =>
            TBR.threshold_hit = false
          , 666

  previousSection: =>
    console.log TBR.data.pages[TBR.active_page_index].slug
    if @activeSectionIndex > 0
      @activeSectionIndex -= 1
      @updateDetailSlider()

      TBR.$body.trigger('footer_collapse')

    else if @activeSectionIndex == 0
      # @suspend_detail()
      href = TBR.data.pages[TBR.active_page_index].slug
      History.pushState(null, null, "/#{href}")

  nextSection: =>
    if @activeSectionIndex < @totalSections - 1
      @activeSectionIndex += 1
      @updateDetailSlider()

      if @totalSections - 1 is @activeSectionIndex
        TBR.$body.trigger('footer_expand')

  changeShirts: (e) =>
    if e.target.id == 'black-hover'
      @$black_shirt.removeClass('hide-shirt')
      @$white_shirt.addClass('hide-shirt')

    else if e.target.id == 'white-hover'
      @$white_shirt.removeClass('hide-shirt')
      @$black_shirt.addClass('hide-shirt')

  ###
  *------------------------------------------*
  | updateDetailSlider:void (-)
  |
  | Update detail slider.
  *----------------------------------------###
  updateDetailSlider: ->
    y = -(@activeSectionIndex * 100)
    @$detail_slider.css(TBR.utils.transform, TBR.utils.translate(0,"#{y}%"))

  ###
  *------------------------------------------*
  | activate_detail:void (-)
  |
  | Activate detail.
  *----------------------------------------###
  activate_detail: ->
    @in_detail = true
    @activeSectionIndex = 0

    @model.getE().addClass('detail-mode')


  ###
  *------------------------------------------*
  | suspend_detail:void (-)
  |
  | Suspend detail.
  *----------------------------------------###
  suspend_detail: ->
    @in_detail = false
    @model.getE().removeClass('detail-mode')

  ###
  *------------------------------------------*
  | activate:void (-)
  |
  | Activate.
  *----------------------------------------###
  activate: ->
    @model.getE().addClass('active')

    if TBR.router.getState().key.split(':')[1] is "detail"
      @model.getE()
       .off("mousewheel.#{@id} mousedown.#{@id} touchstart.#{@id} mousemove.#{@id} touchmove.#{@id}")
       .on("mousewheel.#{@id}", @onMousewheel)
       .on("mousedown.#{@id} touchstart.#{@id}", @onTouchstart)
       .on("mousemove.#{@id} touchmove.#{@id}", @onTouchmove)


  ###
  *------------------------------------------*
  | suspend:void (-)
  |
  | Activate.
  *----------------------------------------###
  suspend: ->
    @model.getE()
      .removeClass('active')
      .off("mousewheel.#{@id} mousedown.#{@id} touchstart.#{@id} mousemove.#{@id} touchmove.#{@id}")

module.exports = MerchController
