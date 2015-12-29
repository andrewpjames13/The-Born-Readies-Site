# Dependencies
Env = require './env'
Routes = require './routes'

# SoundBarn
SoundBarnModel = require './models/base-model'
SoundBarnController = require './controllers/sound-barn-controller'

# NavSlider
NavSliderModel = require './models/base-model'
NavSliderController = require './controllers/nav-slider-controller'

# Home
HomeModel = require './models/home-model'
HomeController = require './controllers/home-controller'

# About
AboutModel = require './models/about-model'
AboutController = require './controllers/about-controller'

# Merch
MerchModel = require './models/merch-model'
MerchController = require './controllers/merch-controller'

class Application

  ###
  *------------------------------------------*
  | constructor:void (-)
  |
  | Construct.
  *----------------------------------------###
  constructor: ->
    # Globals
    TBR.$win = $(window)
    TBR.$doc = $(document)
    TBR.$html = $('html')
    TBR.$body = $('body')
    TBR.data = require './data'
    TBR.utils = require './utils'
    TBR.router = new Routes()
    TBR.active_page_index = 0
    TBR.total_pages = TBR.data.pages.length

    # Class vars
    @$fallback = $('#fallback')
    @$master_slider = $('#master-slider')
    @active_c = null

    # Supported?
    if @$fallback.is(':hidden')
      @$fallback.remove()
      @routes()
      @build()

      # Clicks or flicks?
      if TBR.utils.is_mobile.any() is false
        TBR.$html.addClass('cool-clicks')
      else
        TBR.$html.addClass('finger-blaster')

  ###
  *------------------------------------------*
  | routes:void (-)
  |
  | Set up the routes.
  *----------------------------------------###
  routes: ->
    # Add page routes
    for p in TBR.data.pages
      TBR.router.add("/#{p.slug}", "TBR - #{p.title}")
      if p.detail
        TBR.router.add("/#{p.slug}/detail", "TBR - #{p.title}")

    # Check initial URL
    # If the slug in the url doesn't exist,
    # E.T. phone home!
    state = TBR.router.getState()
    unless TBR.router.routes[state.key]?
      History.replaceState(null, null, '/')

    # Subscribe to page routes
    for p in TBR.data.pages
      TBR.router.on("/#{p.slug}", @goToPage)
      if p.detail
        TBR.router.on("/#{p.slug}/detail", @goToPage)

  ###
  *------------------------------------------*
  | build:void (-)
  |
  | Build.
  *----------------------------------------###
  build: ->
    # SoundBarn Music Player
    @sound_barn_m = new SoundBarnModel({'$el': $('#sound-barn')})
    @sound_barn_c = new SoundBarnController({
      'model': @sound_barn_m
    })

    # NavSlider
    @nav_slider_m = new NavSliderModel({'$el': $('#nav-slider')})
    @nav_slider_c = new NavSliderController({
      'model': @nav_slider_m
    })

    # Home
    @home_m = new HomeModel({'$el': $('#home'), 'id': 'home'})
    @home_c = new HomeController({
      'model': @home_m
    })

    # About
    @about_m = new AboutModel({'$el': $('#about'), 'id': 'about'})
    @about_c = new AboutController({
      'model': @about_m
    })

    # Merch
    @merch_m = new MerchModel({'$el': $('#merch'), 'id': 'merch'})
    @merch_c = new MerchController({
      'model': @merch_m
    })

    # Observe
    @observeSomeSweetEvents()

  ###
  *------------------------------------------*
  | observeSomeSweetEvents:void (-)
  |
  | Observe some sweet events.
  *----------------------------------------###
  observeSomeSweetEvents: ->
    # Trigger the initial route
    TBR.router.onAppStateChange()

  ###
  *------------------------------------------*
  | goToPage:void (=)
  |
  | route:object - current route
  |
  | Go to page.
  *----------------------------------------###
  goToPage: (route) =>
    key_group = route.key.split(':')[0]
    key_detail = route.key.split(':')[1]
    TBR.active_page_index = _.findIndex(TBR.data.pages, {"slug": key_group})

    # What page are we going to next?
    if key_group is ''
      page = @home_c
    else if key_group is 'about'
      page = @about_c
    else if key_group is 'merch'
      page = @merch_c

    # Suspend and activate old/current pages.
    if @active_c is null
      # First timer, so just set current page.
      @active_c = page
      @active_c.activate()
    else
      # Suspend the current page.
      @active_c.suspend()
      # Set our new page from our if statement above
      # and activate this page.
      @active_c = page
      @active_c.activate()

    # Update nav slider on y-axis.
    @nav_slider_c.slideTo()

    # Update master slider on x-axis.
    if key_detail is "detail"
      @nav_slider_c.suspend()
      @$master_slider.addClass('move-it-on-over')
      @active_c.activate_detail()
    else
      @nav_slider_c.activate()
      @$master_slider.removeClass('move-it-on-over')
      if TBR.router.getPreviousState().key.split(':')[1] is "detail"
        @active_c.suspend_detail()

module.exports = Application

$ ->
  # instance
  TBR.instance = new Application()
