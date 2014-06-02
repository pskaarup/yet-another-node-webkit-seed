'use script';

# Declare app level module which depends on filters, and services
app = angular.module 'myApp', [
    'ngRoute'
    'myApp.filters'
    'myApp.services'
    'myApp.directives'
    'myApp.controllers'
]

app.config ['$routeProvider', ($routeProvider) ->
    $routeProvider
    .when '/view1',
        templateUrl: 'partials/view1.html'
        controller: 'MyCtrl1'
    .otherwise redirectTo: '/view1'
    return
]