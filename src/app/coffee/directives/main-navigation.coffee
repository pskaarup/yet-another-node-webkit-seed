'use strict';

angular.module 'myApp.directives'
  .directive 'mainNavigation', ['$location', ($location)->
    restrict: 'E'
    replace: true
    templateUrl: 'templates/directives/main-navigation.html'
    link: (scope, element, attr) ->
      scope.redirect = (event, uri) ->
        $location.path uri
        event.preventDefault()

      scope.isActive = (link) ->
        path = $location.path()
        res = path == link
        res

      scope.tabs = [
          title: 'intro'
          link: '/'
        ,
          title: 'todo'
          link: '/todo'
        ,
          title: 'd3'
          link: '/d3'
      ]
  ]