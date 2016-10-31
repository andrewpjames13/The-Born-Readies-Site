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
    @$detail_slider = $('.detail-slider', @model.getV())
    @$section = $('section', @model.getV())

    @sectionCount = 0
    @activeSectionIndex = 0
    @in_detail = false
    @totalSections = @$section.length

    @photoArray = TBR.data.pages[1].detail.sections[1].photos
    @currentPhotoIndex = 0

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
      @activeSectionIndex -= 1
      @updateDetailSlider()

      TBR.$body.trigger('footer_collapse')

  nextSection: =>
    if @activeSectionIndex < @totalSections - 1
      @activeSectionIndex += 1
      @updateDetailSlider()

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

      @model.getE()
       .off("mousewheel.#{@id}")
       .on("mousewheel.#{@id}", @onMousewheel)
  ###
  *------------------------------------------*
  | suspend:void (-)
  |
  | Activate.
  *----------------------------------------###
  suspend: ->
    @model.getE()
    .removeClass('active')
    .off("mousewheel.#{@id}")

module.exports = AboutController
