class MainNavController

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
    @model.setV($(JST["main-nav-view"]()))
    @model.getE().append(@model.getV())

    #Class vars
    @navOpen = false
    @$navContainer = $('.nav-container')
    @$menuIcon = $('#menu-icon', @model.getV())

    # Observe
    @observeSomeSweetEvents()


  ###
  *------------------------------------------*
  | observeSomeSweetEvents:void (-)
  |
  | Observe some sweet events.
  *----------------------------------------###
  observeSomeSweetEvents: ->
    @$menuIcon.on("click", @toggleNav)

  toggleNav: =>
    if @navOpen is false
      @navOpen = true
      # @$navContainer.animate { opacity: '.95' }, 200, ->
      @$navContainer.removeClass('closed').addClass('open')
    else
      @navOpen = false
      # @$navContainer.animate { opacity: '0' }, 200, ->
      @$navContainer.removeClass('open').addClass('closed')

module.exports = MainNavController
