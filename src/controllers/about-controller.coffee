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
    @model.setV($(JST["#{@id}-view"](_.findWhere(DEMO.data.pages, {"id": @id}))))
    @model.getE().append(@model.getV())

  ###
  *------------------------------------------*
  | transitionOut:void (-)
  |
  | Transition out.
  *----------------------------------------###
  transitionOut: (cb) ->
    @model.getE()
      .removeClass('active')
      .off(DEMO.utils.transition_end)
      .one(DEMO.utils.transition_end, cb)

  ###
  *------------------------------------------*
  | activate:void (-)
  |
  | Activate.
  *----------------------------------------###
  activate: ->
    console.log 'activate about'
    @model.getE().addClass('active')

  ###
  *------------------------------------------*
  | suspend:void (-)
  |
  | Activate.
  *----------------------------------------###
  suspend: ->
    console.log 'suspend about'

module.exports = AboutController