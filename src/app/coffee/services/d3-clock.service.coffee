angular.module 'myApp.services'
  .factory 'd3ClockModel', ['$rootScope', 'Timeouts', ($rootScope, Timeouts) ->

    time = 
        date: new Date()
        hr: 0
        min: 0
        sec: 0
        msec: 0

    decimals = 3
    setTime = (date) ->
      time.hr = date.getHours() # date spec says hrs go from 0-23

      time.min = date.getMinutes()

      time.sec = date.getSeconds()

      time.msec = date.getMilliseconds()
      time.date = date
      # console.log JSON.stringify time

    tick = () ->
      # setTime new Date(2014, 6, 6, 12, 12, 59, 0)
      setTime new Date()

    timeStep = 50
    stepTime = () ->
      setTimeout () ->
        setTime new Date
        $rootScope.$apply()
        tId = setTimeout stepTime, timeStep
        Timeouts.update tId, timeoutOid
        return
      , timeStep

    timeoutOid = "d3ClockModel"

    stop = () ->
      Timeouts.remove timeoutOid
      # if pOptions.timeoutID? then clearTimeout pOptions.timeoutID

    start = () ->
      if not Timeouts.exists timeoutOid
        tId = stepTime()
        Timeouts.add tId, timeoutOid

      # if pOptions.timeoutID == undefined
        # sc = scope
        # pOptions.timeoutID = stepTime()

    api =
      time: time
      start: start
      stop: stop
      tick: tick
  ]

#   serv = angular.module 'bs.services', []

# serv.factory 'MapModel', [()->