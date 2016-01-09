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
    @aboutThreshold_hit = false
    @sectionCount = 0
    @sectionTitle = ""
    @activeSectionIndex = 0
    @totalSections = 0
    @$bottomBorder = $('.bottom-border')
    @$musicMenu = $('#music-menu')
    @$musicList = $('.menu-controls')
    # Observe
    @observeSomeSweetEvents()

  observeSomeSweetEvents: ->
    @$lightening.on("click", @moveItOnOver)

  moveItOnOver: =>
    $('.detail > section').css(TBR.utils.transform, TBR.utils.translate(0, "0%"))
    href = TBR.data.pages[TBR.active_page_index].detail.slug
    History.pushState(null, null, "/#{href}")

  ###
  *------------------------------------------*
  | onMousewheel:void (=)
  |
  | Mousewheelie.
  *----------------------------------------###
  onMousewheel: (e) =>
    e.preventDefault()

    @sectionTitle = TBR.data.pages[TBR.active_page_index].detail.sections[@sectionCount].title
    @activeSectionIndex = _.findIndex(TBR.data.pages[TBR.active_page_index].detail.sections, {"title": @sectionTitle})
    @totalSections = TBR.data.pages[TBR.active_page_index].detail.sections.length

    if @aboutThreshold_hit is false
      d = (e.deltaY * e.deltaFactor)
      if Math.abs(d) >= 20
        @aboutThreshold_hit = true
        if d > 0
          @previousSection()
        else if d < 0
          @nextSection()
        setTimeout =>
          @aboutThreshold_hit = false
        , 666

  previousSection: =>
    if @activeSectionIndex > 0
      @sectionCount -= 1
      @slideSection()
      @$bottomBorder.animate { height: '1.5em' }, 800
      @$musicMenu.animate { bottom: '0' }, 800
      @$musicList.animate { bottom: '0' }, 800
      $('.footer-container').removeClass('open').addClass('closed')

  nextSection: =>
    if @activeSectionIndex < @totalSections - 1
      @sectionCount += 1
      @slideSection()
      if @totalSections - 1 is @activeSectionIndex
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
  slideSection: ->
    yMover = -(@sectionCount * 100)
    $('.detail > section').css(TBR.utils.transform, TBR.utils.translate(0, "#{yMover}%"))
    @sectionTitle = TBR.data.pages[TBR.active_page_index].detail.sections[@sectionCount].title
    @activeSectionIndex = _.findIndex(TBR.data.pages[TBR.active_page_index].detail.sections, {"title": @sectionTitle})

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
