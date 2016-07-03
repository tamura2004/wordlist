$ ->
  csrftoken = document.querySelector("meta[name=csrf-token]").content

  new Vue
    el: "#app"
    data:
      sortkey: "created_at"
      sortorder: "-1"
      query: ""
      status:
        login: false
      user: ""
      name: ""
      desc: ""
      words: []

    created: ->
      @$http.get("words.json").then(
        (response) -> @words = response.data
        (response) -> console.log response
      )

      @$http.get("session.json").then(
        (response) ->
          if response.data.name?
            @user = response.data.name
            @status.login = true
        (response) -> console.log response
      )

      document.getElementById("new").firstElementChild.focus()

    methods:
      logoff: ->
        @user = ""
        @status.login = false

      login: (e) ->
        name = e.target.value
        if @isZen(name) and name isnt ""
          user = name: name
          opt = headers: "X-CSRF-Token": csrftoken

          @$http.post("session.json", user, opt).then(
            (response) ->
              @user = response.data.name
              @status.login = true

            (response) -> console.log response
          )
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

        @$http.post("words.json", word).then (response) ->
          @words.unshift response.data

      isZen: (str) ->
        check = true
        for i in [0...str.length]
          if escape(str.charAt(i)).length < 4
            check = false

        check
