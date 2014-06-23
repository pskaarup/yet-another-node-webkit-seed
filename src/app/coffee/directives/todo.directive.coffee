'use strict';

angular.module 'myApp.directives'
  .directive 'todo', ['TodoModel', '$location', (TodoModel, $location) ->
    restrict: 'A'
    templateUrl: 'templates/directives/todo.directive.html'
    
    link: (scope, element, attr) ->
      scope.todos = TodoModel.todo
      scope.isWarn = (todo) ->
        TodoModel.isWarn(todo)

      scope.isDanger = (todo) ->
        TodoModel.isDanger(todo)

      scope.removeTodo = (todo) ->
        todo.complete = true
        TodoModel.remove todo



      ### Setup for date picker ###
      scope.dateOptions =
        formatYear: 'yy'
        startingDay: 1
      scope.minDate = new Date()
      scope.format = 'dd-MMMM-yyyy'

      scope.open = (e) ->
        e.preventDefault()
        e.stopPropagation()
        scope.opened = true

      scope.addTodo = (e, form) ->
        e.preventDefault()
        e.stopPropagation()
        f = {}
        angular.copy form.fields, f
        form.fields = {} # reset form
        TodoModel.add f.title, f.fullText ? "", f.date
        # Todo add focus on add item

  ]