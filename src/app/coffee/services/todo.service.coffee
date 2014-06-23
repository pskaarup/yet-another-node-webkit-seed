angular.module 'myApp.services'
  .factory 'TodoModel', [() ->

    now = new Date()
    min = 60000
    hr = min * 60
    hr4 = hr * 4
    day = hr * 24

    todos = [
        text: "Write Todo - over one day"
        fullText: "This todo is overdue by more then 24 hrs and is therefore red"
        dueDate: new Date(now - day - min)
        complete: false
      ,
        text: "Write Todo - 5 hours"
        fullText: "This todo is overdue by more then 24 hrs and is therefore orangie"
        dueDate: new Date(now - hr4 - min)
        complete: false
      ,
        text: "Another todo"
        fullText: "This is todo is due in 24 hrs and is white."
        dueDate: new Date(now + day + min)
        complete: false
      ,
        text: "Add complied filename to watch notification"
        fullText: "When a watched file is compiled, add the name of the file to the notification"
        dueDate: new Date(now + day + min)
        complete: false
      ]

    alert = (todo) ->
      diff = now - todo.dueDate
      if diff > day then return 'danger'
      if diff > hr4 then return 'warn'

    isWarn = (todo) ->
      alert(todo) == 'warn'

    isDanger = (todo) ->
      alert(todo) == 'danger'

    remove = (todo) ->
      idx = todos.indexOf todo
      if idx > -1 then todos.splice idx, 1

    add = (_text_, _fullText_, _dueDate_) ->
      todos.push
        text: _text_
        fullText: _fullText_
        dueDate: _dueDate_
        complete: false

    api =
      todo: todos
      isWarn: isWarn
      isDanger: isDanger
      add: add
      remove: remove
  ]

#   serv = angular.module 'bs.services', []

# serv.factory 'MapModel', [()->