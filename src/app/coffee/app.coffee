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
    .when '/',
        templateUrl: 'templates/intro.html'
        controller: 'MainCtrl'
    .otherwise redirectTo: '/'
    return
]

# Declaring modules, do not define anything here
angular.module 'myApp.filters', []
angular.module 'myApp.services', []
angular.module 'myApp.directives', []
angular.module 'myApp.controllers', ['ui.bootstrap']
