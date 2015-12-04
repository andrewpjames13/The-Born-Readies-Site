# Dependencies
Env = require './env'
Routes = require './routes'

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
    @$pages = $('#pages')
    @$mask = $('#mask')
    @$fallback = $('#fallback')
    @active_c = null

    # Supported?
    if @$fallback.is(':hidden')
      @$fallback.remove()
      # @routes()
      # @build()

    # Clicks or flicks?
    if DEMO.utils.is_mobile.any() is false
      DEMO.$html.addClass('cool-clicks')
    else
      DEMO.$html.addClass('finger-blaster')

module.exports = Application

$ ->
  # instance
  DEMO.instance = new Application()