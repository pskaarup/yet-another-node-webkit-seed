'use strcit';

angular.module 'myApp.controllers'
  .controller 'MainCtrl', [
    '$scope'
    ($scope) ->
      $scope.message = "This is a message from the main controller! Hello Wrold!"
    ]