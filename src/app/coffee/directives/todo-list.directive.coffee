'use strict';

angular.module 'myApp.directives'
  .directive 'todoList', ['$location', 'TodoModel', ($location, TodoModel) ->
    restrict: 'A'
    templateUrl: 'templates/directives/todo-list.directive.html'
    
    link: (scope, element, attr) ->
      scope.todos = TodoModel.todo
      scope.isWarn = (todo) ->
        TodoModel.isWarn(todo)

      scope.isDanger = (todo) ->
        TodoModel.isDanger(todo)
  ]