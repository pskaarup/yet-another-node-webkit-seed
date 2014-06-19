angular.module 'myApp.services'
  .factory 'Timeouts', [() ->
    ###
    contains objects of type:
    {
      tId: int
      global: bool
    }
    where the index of the object is a unique string
    ###
    tos = []
    ###
    Point if this task is to have a singleton containing all
    timeout ids such that those no longer required upon change of view can be destroyed
    ###

    ###
    add a timeout to the set with:
    tId: tId of the timeout i.e. tId = setTimeout(...)
    oid: unique string, use name of your directive, service 
      etc. as they should be unique within the application
    global: boolean, if true timeout will no get killed upon running prune()

    POSTCONDITION: if _oid_ exists the existing one is stopped and the new one added
    ###
    add = (_id_, _oid_, _global_)->
      if not _.isNumber(_id_) && _id_ % 1 != 0 then throw "Argument tId must be a number"
      if not _.isString(_oid_) then throw "Argument oid must be a string"

      lookup = tos[_oid_]
      if not lookup?
        tos[_oid_] =
          tId: _id_
          global: if _global_? then _global_ else false
      else
        remove _oid_

    ### using the oid finds and executes clearTimeout(...) on the mathcing tId ###
    remove = (_oid_) ->
      task = tos[_oid_]
      if task?
        clearTimeout task.tId
        idx = tos.indexOf _oid_
        if idx > -1 then tos.splice idx, 1

    update = (_id_, _oid_, _global_) ->
      tOut = tos[_oid_]

      if not tOut?
        throw "oid was not found. Did you remove it by acciden't or never added it?"
      else
        tOut.tId = _id_
        tOut.global = if _global_? then _global_ else false

    exists = (_oid_) ->
      tos[_oid_]?

    ###
    prune runs through the map of timeouts and executes clearTimeout(...) on those
    not global = true
    ###
    prune = () ->
      globals = []
      _.each tos, (val, key, list) ->
        if val.global
          globals[key] = val
        else
          remove val.oid
      tos = globals


    api =
      add:      add
      remove:   remove
      exists:   exists
      update:   update
      prune:    prune
  ]