# Dependencies
Env = require './env'
Routes = require './routes'

# Header
HeaderModel = require './models/base-model'
HeaderController = require './controllers/header-controller'

# Home
HomeModel = require './models/base-model'
HomeController = require './controllers/home-controller'

# About
AboutModel = require './models/base-model'
AboutController = require './controllers/about-controller'

# Projects
ProjectsModel = require './models/base-model'
ProjectsController = require './controllers/projects-controller'

class Application

  ###
  *------------------------------------------*
  | constructor:void (-)
  |
  | Construct.
  *----------------------------------------###
  constructor: ->
    # Globals
    DEMO.$win = $(window)
    DEMO.$doc = $(document)
    DEMO.$html = $('html')
    DEMO.$body = $('body')

    DEMO.data = require './data'
    DEMO.utils = require './utils'
    DEMO.router = new Routes()

    # Class vars
    @$fallback = $('#fallback')
    @active_c = null

    # Supported?
    if @$fallback.is(':hidden')
      @$fallback.remove()
      @routes()
      @build()

    # Clicks or flicks?
    if DEMO.utils.is_mobile.any() is false
      DEMO.$html.addClass('cool-clicks')
    else
      DEMO.$html.addClass('finger-blaster')

  ###
  *------------------------------------------*
  | routes:void (-)
  |
  | Set up the routes.
  *----------------------------------------###
  routes: ->
    # Add page routes
    for i, p of DEMO.data.pages
      DEMO.router.add("/#{p.slug}", "DEMO - #{p.title}")

    # Check initial URL
    state = DEMO.router.getState()
    unless DEMO.router.routes[state.key]?
      History.replaceState(null, null, '/')

    # Subscribe to page routes
    for i, p of DEMO.data.pages
      DEMO.router.on("/#{p.slug}", @goToPage)

  ###
  *------------------------------------------*
  | build:void (-)
  |
  | Build.
  *----------------------------------------###
  build: ->
    # Header
    @header_m = new HeaderModel({'$el': $('header')})
    @header_c = new HeaderController({
      'model': @header_m
    })

    # About
    @about_m = new AboutModel({'$el': $('#about')})
    @about_c = new AboutController({
      'model': @about_m
    })

    # Home
    @home_m = new HomeModel({'$el': $('#home')})
    @home_c = new HomeController({
      'model': @home_m
    })

    # Projects
    @projects_m = new ProjectsModel({'$el': $('#projects')})
    @projects_c = new ProjectsController({
      'model': @projects_m
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
    DEMO.router.onAppStateChange()

  ###
  *------------------------------------------*
  | goToPage:void (=)
  |
  | route:object - current route
  |
  | Go to page.
  *----------------------------------------###
  goToPage: (route) =>
    route_key = route.key
    id = if route.url is '/' then 'home' else route.key.split(':')[0]
    @header_c.setState(id)

    if route_key is ''
      page = @home_c
    else if route_key is 'about'
      page = @about_c
    else
      page = @projects_c

    if @active_c isnt null
      @active_c.transitionOut(=>
        @suspend()
        @active_c = page
        @active_c.activate()
      )
    else
      @active_c = page
      @active_c.activate()

  ###
  *------------------------------------------*
  | suspend:void (-)
  |
  | Suspend all.
  *----------------------------------------###
  suspend: ->
    if @active_c isnt null
      @active_c.suspend()

module.exports = Application

$ ->
  # instance
  DEMO.instance = new Application()