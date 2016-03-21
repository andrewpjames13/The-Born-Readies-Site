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

    # Observe
    @observeSomeSweetEvents()


  ###
  *------------------------------------------*
  | observeSomeSweetEvents:void (-)
  |
  | Observe some sweet events.
  *----------------------------------------###
  observeSomeSweetEvents: ->
    count = 0
    counting = setInterval((->
      if count < 101
        $('.loading-value').text count + '%'
        count++
        # count = count + 10
      else
        $('#fully-loader').removeClass('show')
        clearTimeout(counting)
      return
    ), 70)




module.exports = FullyLoaderController
