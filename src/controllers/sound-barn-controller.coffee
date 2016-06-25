class SoundBarnController

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
    @model.setV($(JST["sound-barn-view"]()))
    console.log @model.getE()
    @model.getE().append(@model.getV())

    #Class vars
    @$pauseIcon = $("#pause-icon", @model.getV())
    @$playIcon = $('#play-icon', @model.getV())
    @tbrSongs = ["You Really Turn Me On", "Wildside", "Get After It", "Fallen"]
    @songInt = 0
    @nowPlaying = new Audio("songs/" + @tbrSongs[@songInt] + ".mp3")
    @randomSongInt = 0
    @menuOpen = false
    @myTimeOut = null
    @currentVolume = 0
    @$trigger = $('.trigger', @model.getV())
    @$shuffleButton = $('#shuffle-song', @model.getV())
    @$nextButton = $('#next-song', @model.getV())
    @$playPauseButton = $('#play-pause-button', @model.getV())
    # Observe
    @observeSomeSweetEvents()
    # First song to play and listen for end
    @$playPauseButton.addClass("pause-btn")
    @nowPlaying.volume = @currentVolume
    @nowPlaying.pause()
    @playNextWhenSongEnds()

  ###
  *------------------------------------------*
  | observeSomeSweetEvents:void (-)
  |
  | Observe some sweet events.
  *----------------------------------------###
  observeSomeSweetEvents: ->
    fadeItIn = setInterval((=>
      if @currentVolume <= 1
        @nowPlaying.volume = @currentVolume
        @currentVolume += .05
      else
        clearTimeout(fadeItIn)
      return
    ), 200)

    @model.getV().on("mouseenter", @stopTimeOut)
    @$trigger.on("click", @toggleMenu)
    @$shuffleButton.on("click", @shuffleSong)
    @$nextButton.on("click", @nextSong)
    @$playPauseButton.on("click", @playPauseFlip)
  #  Player controls
  playPauseFlip: =>
    if @nowPlaying.paused
      @nowPlaying.play()
      @$playPauseButton.removeClass("play-btn").addClass("pause-btn")
    else
      @nowPlaying.pause()
      @$playPauseButton.removeClass("pause-btn").addClass("play-btn")

  nextSong: =>
    if @songInt < @tbrSongs.length - 1
      @songInt += 1
      @stopAndStartNewSong(@songInt)
    else
      @songInt = 0
      @stopAndStartNewSong(@songInt)

    @playNextWhenSongEnds()

  shuffleSong: =>
    @randomSongInt = Math.floor(Math.random() * (3 + 1))
    if @randomSongInt is @songInt
      @shuffleSong()
    else
      @songInt = @randomSongInt
      @stopAndStartNewSong(@songInt)

    @playNextWhenSongEnds()

  # functions for the player
  stopAndStartNewSong: (songInt) =>
    if @nowPlaying.paused
      @nowPlaying = new Audio("songs/" + @tbrSongs[songInt] + ".mp3")
    else
      @nowPlaying.pause()
      @nowPlaying = new Audio("songs/" + @tbrSongs[songInt] + ".mp3")
      @nowPlaying.play()

  playNextWhenSongEnds: =>
    $(@nowPlaying).off("ended").one("ended", @nextSong)

  # Open and close player menu
  looseFocusCloseMenu: =>
    clearTimeout(@myTimeOut)
    @myTimeOut = setTimeout =>
      @model.getV().removeClass("menu-open")
      @menuOpen = false
    , 800

  stopTimeOut: =>
    if @menuOpen is true
      clearTimeout(@myTimeOut)

  toggleMenu: =>
    if @menuOpen is false
      @menuOpen = true
      @model.getV().addClass("menu-open")
      @model.getV().off("mouseleave").on("mouseleave", @looseFocusCloseMenu)
    else
      @menuOpen = false
      @model.getV().removeClass("menu-open")

module.exports = SoundBarnController
