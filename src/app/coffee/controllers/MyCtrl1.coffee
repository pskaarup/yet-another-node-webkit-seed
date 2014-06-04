'use strict'

ctrls = angular.module 'myApp.controllers', []

ctrls.controller "MyCtrl1", ['$scope', ($scope) ->
    $scope.message = "Hello World"
]
