class Routes

  ###
  *------------------------------------------*
  | constructor:void (-)
  |
  | Construct.
  *----------------------------------------###
  constructor: ->
    @url_regex = /[^a-z0-9*:_-]+/gi
    @prev_state = History.getState()
    @state = History.getState()
    @routes = {}

    @observeSomeSweetEvents()

  ###
  *------------------------------------------*
  | observeSomeSweetEvents:void (-)
  |
  | Observe events scoped to this class.
  *----------------------------------------###
  observeSomeSweetEvents: ->
    History.Adapter.bind(window, 'statechange', @onAppStateChange)
    TBR.$body.on('click', '.ajaxy', @onAjaxyLinkClick)

  ###
  *------------------------------------------*
  | onAjaxyLinkClick:void (=)
  |
  | e:object - event object
  |
  | User has clicked an ajaxy link.
  *----------------------------------------###
  onAjaxyLinkClick: (e) =>
    e.preventDefault()
    if e.which is 2 or e.metaKey is true then return true

    href = $(e.currentTarget).attr('href')
    History.pushState(null, null, href)

  ###
  *------------------------------------------*
  | onAppStateChange:void (=)
  |
  | App state (URL) has changed.
  *----------------------------------------###
  onAppStateChange: =>
    @prev_state = @state
    @state = History.getState()
    @route(@state.hash)

  ###
  *------------------------------------------*
  | sanitizeKey:void (-)
  |
  | url:string - url
  |
  | Make a key for storing callbacks.
  *----------------------------------------###
  sanitizeKey: (url) ->
    return url.replace(/^\/|\/$/g, '').split('/').join(':').replace(@url_regex, '')

  ###
  *------------------------------------------*
  | format:void (-)
  |
  | url:string - url
  |
  | Format the added route.
  *----------------------------------------###
  format: (url) ->
    obj = {}

    url = if url.indexOf('?') isnt -1 then url.split('?')[0] else url
    url = url.replace(/[\#\.]/g, '')
    url = url.replace(/^(?!\/)(.+)$/, '/$1')

    if url is '/'
      obj = {'key': '', 'url': url}
    else
      obj = {'key': @sanitizeKey(url), 'url': url}

    return obj

  ###
  *------------------------------------------*
  | route:void (-)
  |
  | to:string - url
  |
  | Route to the passed url.
  *----------------------------------------###
  route: (to) ->
    state = @format(to)

    if @routes[state.key]?
      for cb in @routes[state.key].callbacks
        cb(@format(@state.hash))

      document.title = @routes[state.key].title

  ###
  *------------------------------------------*
  | on:void (-)
  |
  | route:string - url
  | cb:function - callback
  |
  | Fire a callback.
  *----------------------------------------###
  on: (route, cb) ->
    state = @format(route)

    # Handle wildcards
    if state.key.indexOf('*') isnt -1
      part = state.key.split(':')[0]

      for key in _.keys(@routes)
        if key.indexOf(part) isnt -1
          @on(key, cb)

      return false

    # Add callback
    if @routes[state.key]? is false
      throw('Error: The route needs to be defined in routes.coffee!')
    else
      @routes[state.key].callbacks.unshift(cb)

  ###
  *------------------------------------------*
  | add:void (-)
  |
  | route:string - url
  | title:string - route title
  |
  | Add a route.
  *----------------------------------------###
  add: (route, title) ->
    state = @format(route)
    @routes[state.key] = {
      'callbacks': [],
      'title': title
    }

  ###
  *------------------------------------------*
  | getState:string (-)
  |
  | Get the current state.
  *----------------------------------------###
  getState: ->
    return @format(@state.hash)

  ###
  *------------------------------------------*
  | getPreviousState:string (-)
  |
  | Get the previous state.
  *----------------------------------------###
  getPreviousState: ->
    return @format(@prev_state.hash)

module.exports = Routes
