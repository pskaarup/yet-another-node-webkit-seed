'use strict';

angular.module 'myApp.directives'
  .directive 'mainNavigation', [->
    restrict: 'A'
    # replace: true
    templateUrl: 'templates/main-navigation.html'
  ]