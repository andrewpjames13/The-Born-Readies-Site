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

    @$button = $('button', @model.getV())
    @$detail_slider_container = $('.detail-slider-container', @model.getV())
    @$detail_slider = $('.detail-slider', @model.getV())
    @$section = $('section', @model.getV())

    @sectionCount = 0
    @activeSectionIndex = 0
    @in_detail = false
    @totalSections = @$section.length

    @photoArray = TBR.data.pages[1].detail.sections[1].photos
    @currentPhotoIndex = 0

    # Draggable vars
    @dragging = false
    @drag_time = 512
    @start_time = 0
    @start_y = 0
    @current_y = 0
    @direction_y = 0
    @current_range_y = 0
    @now = 0

    # Observe
    @observeSomeSweetEvents()

  observeSomeSweetEvents: ->
    @$button.on("click", @moveItOnOver)
    $('.photo').on("click", @expandPhoto)
    $('#photo-light-box').on("click", @closePhoto)
    $('#photo-light-box').bind("mousewheel", @photoWheelin)

  expandPhoto: (e) =>
    @currentPhotoIndex = e.target.attributes.index.value
    clickedPhoto = @photoArray[@currentPhotoIndex]
    $('#photo-light-box').addClass('show')
    $('.display-photo').attr("src", clickedPhoto)

  closePhoto: () =>
    $('#photo-light-box').removeClass('show')

  photoWheelin: (e) =>
    if $('#photo-light-box').hasClass('show')
      e.preventDefault

      if TBR.threshold_hit is false
        d = (e.deltaX * e.deltaFactor)
        if Math.abs(d) >= 20
          TBR.threshold_hit = true
          if d > 0
            if @currentPhotoIndex == @photoArray.length - 1
              @currentPhotoIndex = 0
            else
              @currentPhotoIndex = parseInt(@currentPhotoIndex) + 1
            nextPhoto = @photoArray[@currentPhotoIndex]
            $('.display-photo').attr("src", nextPhoto)
            # @previousSection()
          else if d < 0
            if @currentPhotoIndex == 0
              @currentPhotoIndex = @photoArray.length - 1
            else
              @currentPhotoIndex = parseInt(@currentPhotoIndex) - 1
            prevPhoto = @photoArray[@currentPhotoIndex]
            $('.display-photo').attr("src", prevPhoto)
            # @nextSection()
          setTimeout =>
            TBR.threshold_hit = false
          , 666

  moveItOnOver: =>
    href = TBR.data.pages[TBR.active_page_index].detail.slug
    History.pushState(null, null, "/#{href}")
    $('#you-are-here-about-detail').removeClass('hide')

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
        .off("mouseup.#{@id} touchend.#{@id}")
        .one("mouseup.#{@id} touchend.#{@id}", @onTouchend)

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
    if @activeSectionIndex == 0
      href = TBR.data.pages[TBR.active_page_index].slug
      History.pushState(null, null, "/#{href}")
    else if @activeSectionIndex > 0
      $("." + TBR.data.pages[1].detail.sections[@activeSectionIndex].id).removeClass('active')
      @activeSectionIndex -= 1
      @updateDetailSlider()
      $("." + TBR.data.pages[1].detail.sections[@activeSectionIndex].id).addClass('active')

      TBR.$body.trigger('footer_collapse')

  nextSection: =>
    if @activeSectionIndex < @totalSections - 1
      $("." + TBR.data.pages[1].detail.sections[@activeSectionIndex].id).removeClass('active')
      @activeSectionIndex += 1
      @updateDetailSlider()
      $("." + TBR.data.pages[1].detail.sections[@activeSectionIndex].id).addClass('active')

      if @totalSections - 1 is @activeSectionIndex
        TBR.$body.trigger('footer_expand')

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

      @$detail_slider_container
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
    @model.getE().removeClass('active')
    @$detail_slider_container.off("mousewheel.#{@id} mousedown.#{@id} touchstart.#{@id} mousemove.#{@id} touchmove.#{@id}")

module.exports = AboutController
