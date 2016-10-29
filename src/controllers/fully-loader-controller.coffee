class FullyLoaderController

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
    @model.setV($(JST["fully-loader-view"]()))
    @model.getE().append(@model.getV())

    #Class vars
    @total = 0
    @loaded = 0
    @percent = 0
    @$fillBar = $('.loader-bar-top', @model.getE())

  ###
  *------------------------------------------*
  | getLoaded:void (=)
  |
  | Get loaded!
  *----------------------------------------###
  getLoaded: =>
    @total = TBR.assets.length
    for image, index in TBR.assets
      @loadOneImage(image)

  ###
  *------------------------------------------*
  | loadOneImage:void (-)
  |
  | Load one image.
  *----------------------------------------###
  loadOneImage: (image) =>
    $current = $('<img />').attr
      'src': image
    .one 'load', (e) =>
      @loaded++
      @updateProgress()

    if $current[0].complete is true
      $current.trigger('load')

    return $current[0]

  ###
  *------------------------------------------*
  | updateProgress:void (=)
  |
  | Update progress.
  *----------------------------------------###
  updateProgress: =>
    @percent = (@loaded / @total) * 100
    if @percent <= 25
      @topPercent = @percent * 4
      @$fillBar.css('width', "#{@topPercent}%")

    if @loaded is @total
      @totallyLoaded()

  ###
  *------------------------------------------*
  | totallyLoaded:void (=)
  |
  | totally loaded!
  *----------------------------------------###
  totallyLoaded: =>
    $('#fully-loader').removeClass('show')




module.exports = FullyLoaderController
