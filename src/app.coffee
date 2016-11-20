# Dependencies
Env = require './env'
Routes = require './routes'

# SoundBarn
SoundBarnModel = require './models/base-model'
SoundBarnController = require './controllers/sound-barn-controller'

# MainNav
MainNavModel = require './models/base-model'
MainNavController = require './controllers/main-nav-controller'

# YouAreHere
YouAreHereModel = require './models/base-model'
YouAreHereController = require './controllers/you-are-here-controller'

# YouAreHereDetail
YouAreHereDetailModel = require './models/base-model'
YouAreHereDetailController = require './controllers/you-are-here-detail-controller'

# YouAreHereAboutDetail
YouAreHereAboutDetailModel = require './models/base-model'
YouAreHereAboutDetailController = require './controllers/you-are-here-about-detail-controller'

# Footer
FooterModel = require './models/base-model'
FooterController = require './controllers/footer-controller'

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

# Home
ContactModel = require './models/contact-model'
ContactController = require './controllers/contact-controller'

# Loader
FullyLoaderModel = require './models/base-model'
FullyLoaderController = require './controllers/fully-loader-controller'

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
    TBR.threshold_hit = false
    TBR.assets = []

    # Class vars
    @$fallback = $('#fallback')
    @$master_slider = $('#master-slider')
    @$borders = $('.top-border, .right-border, .bottom-border, .left-border')
    @active_c = null
    @$back_button = $('#back-btn')
    @$nav_button = $('#nav-button')
    @$bottomBorder = $('.bottom-border')
    @$musicMenu = $('#music-menu')
    @$musicList = $('.menu-controls')

    # Supported?
    if @$fallback.is(':hidden')
      @$fallback.remove()

      # Get assets to load
      for page in TBR.data.pages
        if page.poster
          TBR.assets.push(page.poster)

        if page.assets
          for asset in page.assets
            TBR.assets.push(asset)

      @routes()
      @build()

      # Clicks or flicks?
      if TBR.utils.is_mobile.any() is false
        TBR.$html.addClass('cool-clicks')
      else
        TBR.$html.addClass('finger-blaster')

    if TBR.total_pages - 1 is TBR.active_page_index
      $('#music-menu, .menu-controls').animate { bottom: '1.9em' }, 800
      @footerExpand()
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

    # MainNav
    @main_nav_m = new MainNavModel({'$el': $('#main-nav')})
    @main_nav_c = new MainNavController({
      'model': @main_nav_m
    })

    # YouAreHere
    @you_are_here_m = new YouAreHereModel({'$el': $('#you-are-here')})
    @you_are_here_c = new YouAreHereController({
      'model': @you_are_here_m
    })

    # YouAreHereDetail
    @you_are_here_detail_m = new YouAreHereDetailModel({'$el': $('#you-are-here-detail')})
    @you_are_here_detail_c = new YouAreHereDetailController({
      'model': @you_are_here_detail_m
    })

    # YouAreHereAboutDetail
    @you_are_here_about_detail_m = new YouAreHereAboutDetailModel({'$el': $('#you-are-here-about-detail')})
    @you_are_here_about_detail_c = new YouAreHereAboutDetailController({
      'model': @you_are_here_about_detail_m
    })

    # NavSlider
    @nav_slider_m = new NavSliderModel({'$el': $('#nav-slider')})
    @nav_slider_c = new NavSliderController({
      'model': @nav_slider_m
    })

    # Footer
    @footer_m = new FooterModel({'$el': $('#footer')})
    @footer_c = new FooterController({
      'model': @footer_m
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

    # Contact
    @contact_m = new ContactModel({'$el': $('#contact'), 'id': 'contact'})
    @contact_c = new ContactController({
      'model': @contact_m
    })

    # Loader
    @fully_loader_m = new FullyLoaderModel({'$el': $('#fully-loader')})
    @fully_loader_c = new FullyLoaderController({
      'model': @fully_loader_m
    })

    # Get loaded!
    @fully_loader_c.getLoaded()

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

    #set active you are here state
    @setActiveYouAreHere()

    # Custom events!
    TBR.$body
      .on('footer_expand', =>
        @footerExpand()
      )
      .on('footer_collapse', =>
        @footerCollapse()
      )
      .on('set_active_you_are_here', =>
        @setActiveYouAreHere()
      )

    @$nav_button.on('click', @main_nav_c.toggleNav)

  setActiveYouAreHere: =>
    $(".here-nav").removeClass('active')
    $("." + TBR.data.pages[TBR.active_page_index].id).addClass('active')

  footerExpand: =>
    $('.footer-container').addClass('open')
    $('.bottom-border').animate { height: '3em' }, 800
    $('#music-menu').animate { bottom: '2em' }, 800
    $('.menu-controls').animate { bottom: '.5' }, 800

  footerCollapse: =>
    $('.footer-container').removeClass('open')
    $('.bottom-border').animate { height: '1em' }, 800
    $('#music-menu').animate { bottom: '0' }, 800
    $('.menu-controls').animate { bottom: '0' }, 800

    # console.log 'close expand'

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
      $('#music-menu').addClass('home')
      page = @home_c
    else if key_group is 'about'
      page = @about_c
      $('.detail-slider').css(TBR.utils.transform, TBR.utils.translate(0,0))
    else if key_group is 'merch'
      page = @merch_c
      $('.detail-slider').css(TBR.utils.transform, TBR.utils.translate(0,0))
    else if key_group is 'contact'
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
      @$borders.addClass('black')
      @active_c.activate_detail()
      @$borders.addClass('black')
      $('#you-are-here').addClass('hide')
      $('.who').addClass('active')
      $('.ep').addClass('active')

      @$back_button
        .addClass('show')
        .on "click", ->
          href = TBR.data.pages[TBR.active_page_index].slug
          History.pushState(null, null, "/#{href}")
          $('.detail-slider').css(TBR.utils.transform, TBR.utils.translate(0,0))

    else
      @nav_slider_c.activate()
      @$borders.removeClass('black')
      @$back_button.removeClass('show')
      $('#you-are-here').removeClass('hide')
      $('#you-are-here-detail').addClass('hide')
      $('#you-are-here-about-detail').addClass('hide')
      $('.here-nav-detail').removeClass('active')
      if TBR.router.getPreviousState().key.split(':')[1] is "detail"
        if @active_c.suspend_detail
          @active_c.suspend_detail()

module.exports = Application

$ ->
  # instance
  TBR.instance = new Application()
