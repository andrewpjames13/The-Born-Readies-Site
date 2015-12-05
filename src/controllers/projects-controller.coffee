class ProjectsController

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
    @model.setV($(JST['projects-view'](DEMO.data.pages['projects'])))
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
    console.log 'activate projects'
    @model.getE().addClass('active')

  ###
  *------------------------------------------*
  | suspend:void (-)
  |
  | Activate.
  *----------------------------------------###
  suspend: ->
    console.log 'suspend projects'

module.exports = ProjectsController