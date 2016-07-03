# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  new Vue
    el: "#app"
    data:
      sortkey: "name"
      query: ""
      status:
        login: false
      user: ""
      name: ""
      desc: ""
      words: []

    created: ->
      @$http.get "words.json", (data,status,request) ->
        @words.unshift word for word in data

      @$http.get "session.json", (data,status,request) ->
        if data.name?
          @user = data.name
          @status.login = true
        # document.getElementById("new").firstElementChild.focus()

    methods:
      logoff: ->
        @user = ""
        @status.login = false

      login: (e) ->
        name = e.target.value
        if @isZen(name) and name isnt ""
          user = name: name
          console.log user
          @$http.post "session.json", user, (data,status,request) ->
            console.log data
            @user = data.name
            @status.login = true
        else
          alert "名前は全角で入力して下さい"

      shuffle: ->
        @words = _.shuffle @words

      add: ->
        @words.unshift name: "hoge", desc: "fuga"

      remove: (word) ->
        @words = _.filter @words, (w) ->
          w.id isnt word.id

      onEnter: (e) ->
        t = e.target
        switch t.className
          when "item-title"
            t.nextElementSibling.focus() if t.value isnt ""

          when "item-body"
            @insert()
            t.previousElementSibling.focus()

      changeBody: (e) ->
        console.log e.target.value


      insert: ->
        document.getElementById("new").firstElementChild.focus()
        word =
          name: @name.replace(/\n/g,"")
          desc: @desc.replace(/\n/g,"")

        @name = ""
        @desc = ""

        @$http.post "words.json", word, (data,status,request) ->
          @words.unshift data

      isZen: (str) ->
        check = true
        for i in [0...str.length]
          if escape(str.charAt(i)).length < 4
            check = false

        check
