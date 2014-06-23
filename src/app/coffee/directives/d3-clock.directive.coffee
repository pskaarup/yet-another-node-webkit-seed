'use strict';

angular.module 'myApp.directives'
  .directive 'd3Clock', [
    '$location'
    'd3ClockModel'
    'Timeouts'
    ($location, d3ClockModel, Timeouts) ->
      restrict: 'A'
      templateUrl: 'templates/directives/d3-clock.directive.html'
      
      link: (scope, element, attr) ->

        ###
        Stuff for clock
        ###
        scope.stepClock = ->
          # d3ClockModel.tick()
          tick()

        scope.stopClock = ()->
          d3ClockModel.stop()
          Timeouts.remove "clock"

        height= 400
        width= 400

        time = d3ClockModel.time

        flip = (_new_, _old_) ->
          res = _new_ >= _old_
          res

        flippers =
          ms:
            oldValue:      -1
            flip: false
            incEnd: true
          sec:
            oldValue:      -1
            flip: false
            incEnd: true
          min:
            oldValue:      -1
            flip: false
            incEnd: true
          hr:
            oldValue:      -1
            flip: false
            incEnd: true

        setFilpFlops = (time) ->
          f = flippers

          #if ms.tick # in tail incremental mode
          if not flip time.msec, f.ms.oldValue
            f.ms.incEnd = not f.ms.incEnd
            f.ms.flip = f.ms.incEnd

          if not flip time.sec, f.sec.oldValue
            f.sec.incEnd = not f.sec.incEnd
            f.sec.flip = f.sec.incEnd

          if not flip time.min, f.min.oldValue
            f.min.incEnd = not f.min.incEnd
            f.min.flip = f.min.incEnd

          if not flip time.hr, f.hr.oldValue
            f.hr.incEnd = not f.hr.incEnd
            f.hr.flip = f.hr.incEnd

          f.ms.oldValue      = time.msec
          f.sec.oldValue     = time.sec
          f.min.oldValue     = time.min
          f.hr.oldValue      = time.hr
          return

        getAngle = (counter, max, incEndAngle, isEndAngle) ->
          # When incrementing endAngle, startAngle should remain 0
          # When tickover happens startAngle should be increased and endAngle = 2*PI
          if incEndAngle and isEndAngle # inc endAngle and is end angle asking
            return (counter / max) * 2 * Math.PI

          if not incEndAngle and isEndAngle
            return 2 * Math.PI

          if incEndAngle and not isEndAngle
            return 0

          if not incEndAngle and not isEndAngle
            return (counter / max) * 2 * Math.PI


        fields = () ->
          # render data for this instance
          d3ClockModel.tick()

          setFilpFlops time

          objects = [
            type: "msec"
            x: 110
            y: height - 15
            outerRadius:  15
            innerRadius:  5
            startAngle:   getAngle flippers.ms.oldValue,  1000, flippers.ms.incEnd, false
            endAngle:     getAngle flippers.ms.oldValue,  1000, flippers.ms.incEnd, true
            color:        '#C71C38'
          , 
            type: "sec"
            x: 45
            y: height - 45
            outerRadius:  45
            innerRadius:  30
            startAngle:   getAngle flippers.sec.oldValue, 59, flippers.sec.incEnd, false
            endAngle:     getAngle flippers.sec.oldValue, 59, flippers.sec.incEnd, true
            color:        '#5D1CC7'
          , 
            type: "min"
            x: 195
            y: height - 135
            outerRadius:  110
            innerRadius:  90
            startAngle:   getAngle flippers.min.oldValue, 59, flippers.min.incEnd, false
            endAngle:     getAngle flippers.min.oldValue, 59, flippers.min.incEnd, true
            color:        '#86C71C'
          , 
            type: "hr"
            x: 225
            y: 240
            outerRadius:  160
            innerRadius:  155
            startAngle:   getAngle flippers.hr.oldValue,  24, flippers.hr.incEnd, false
            endAngle:     getAngle flippers.hr.oldValue,  24, flippers.hr.incEnd, true
            color:        '#000000'
          ]
          # console.log objects[0].startAngle + " - " + objects[0].endAngle
          b = objects[1]
          objects

        arc = d3.svg.arc()
          .startAngle   (d) -> d.startAngle
          .endAngle     (d) -> d.endAngle
          .innerRadius  (d) -> d.innerRadius
          .outerRadius  (d) -> d.outerRadius

        svg = d3.select "#svg_time"
          .attr "width", width
          .attr "height", height
          .append "g"

        field = svg.selectAll("g")
          .data(fields)
          .enter().append("g")


        field.append "path"

        transform = svg.selectAll("g").each (d) ->
          d3.select(this).attr "transform", "translate(" + d.x + "," + d.y + ")"

        arcTween = (d) ->
          # i = d3.interpolateNumber d.previousValue, d.endAngle
          # TODO rewrite such that when swapping between increasing endAngle and startAngle
          # animate from 0 to angle and not from old angle to new angle
          # e = s = ""
          # if flip(d.prevEndAngle, d.endAngle) and flip(d.prevStartAngle, d.startAngle)
          e = d3.interpolateNumber d.prevEndAngle, d.endAngle
          s = d3.interpolateNumber d.prevStartAngle, d.startAngle
          (tween) -> 
            # d.endAngle = i tween
            # d.endAngle = d.endAngle
            # d.startAngle = d.startAngle
            # if d.type == "msec"
            #   d.endAngle = d.endAngle
            #   d.startAngle = d.startAngle
            # else
            #   d.endAngle = e tween
            #   d.startAngle = s tween
            d.endAngle = e tween
            d.startAngle = s tween
            arc d

        tick = () ->
          field = field
            .each (d) -> 
              this._endAngle = d.endAngle
              this._startAngle = d.startAngle
            .data(fields)
            .each (d) -> 
              d.prevEndAngle = this._endAngle
              d.prevStartAngle = this._startAngle

          field.select "path"
            .transition()
            # .ease("easeInBack")
            .attrTween "d", arcTween
            .style "fill", (d) -> d.color

        first = true
        ticktock = () ->
          tick()
          # tId = setTimeout(ticktock, 10)
          repeat = 333
          if first
            tId = setTimeout ticktock, repeat
            Timeouts.add tId, "clock"
            first = false
          else
            tId = setTimeout ticktock, repeat
            Timeouts.update tId, "clock"

        d3.transition().duration(0).each(ticktock);

        d3.select(self.frameElement).style "height", height + "px"
   
]