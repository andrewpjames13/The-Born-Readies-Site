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
    @threshold_hit = false
    @active_section_index = 0
    @total_sections = TBR.data.pages[1].detail.sections.length
    @$bottomBorder = $('.bottom-border')
    @$musicMenu = $('#music-menu')
    @$musicList = $('.menu-controls')

    # Observe
    @observeSomeSweetEvents()

  observeSomeSweetEvents: ->
    @$lightening.on("click", @moveItOnOver)
    $('.press-btn').on("click", @moveItOnUp)

  moveItOnOver: =>
    href = TBR.data.pages[TBR.active_page_index].detail.slug
    History.pushState(null, null, "/#{href}")

  moveItOnUp: =>
    $('.detail').addClass('move-it-on-up')
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
        if d > 0
          @previousSection()
        else if d < 0
          @nextSection()
        setTimeout =>
          @threshold_hit = false
        , 666

  previousSection: =>
    if @active_section_index > 0
      # @slideTo()
      $('.detail > section').css(TBR.utils.transform, TBR.utils.translate(0, "0%"))
      @active_section_index -= 1
      @$bottomBorder.animate { height: '1.5em' }, 800
      @$musicMenu.animate { bottom: '0' }, 800
      @$musicList.animate { bottom: '0' }, 800
      $('.footer-container').removeClass('open').addClass('closed')
  #
  nextSection: =>
    if @active_section_index < @total_sections - 1
      # @slideTo()
      yMover = -(@active_section_index * 100)
      $('.detail > section').css(TBR.utils.transform, TBR.utils.translate(0, "#{yMover}%"))
      @active_section_index += 1
      console.log @total_sections
      console.log @active_section_index
      if @total_sections - 1 is @active_section_index
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
  # slideTo: ->
  #   y = -(@active_section_index * 100)
  #   $('.detail > section').css(TBR.utils.transform, TBR.utils.translate(0,"#{y}%"))
  #   console.log @active_section_index
  #   console.log y

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
    @model.getE()
      .addClass('active')
      .off('mousewheel')
      .on('mousewheel', @onMousewheel)
  ###
  *------------------------------------------*
  | suspend:void (-)
  |
  | Activate.
  *----------------------------------------###
  suspend: ->
    @model.getE()
    .removeClass('active')
    .off('mousewheel')

module.exports = AboutController
