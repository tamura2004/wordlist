$ ->
  csrftoken = document.querySelector("meta[name=csrf-token]").content
  csrfheader = headers: "X-CSRF-Token": csrftoken

  new Vue
    el: "#app"
    data:
      sortkey: "created_at"
      sortorder: "-1"
      query: ""
      checkSelf: false
      status:
        login: false
      menu:
        rank: false
        word: true
        quiz: false
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
            @checkSelf = true
        (response) -> console.log response
      )

      document.getElementById("new").firstElementChild.focus()

    computed:
      totalRank: -> _.countBy @words, "user"
      monthlyRank: -> _.countBy @words, "user"
      weeklyRank: -> _.countBy @words, "user"

    methods:
      setMenu: (name)->
        for page in ["rank","word","quiz"]
          @menu[page] = (name is page)

      filterSelf: (v)->
        not @checkSelf or v.user is @user

      logoff: ->
        @user = ""
        @status.login = false
        @checkSelf = false

      login: (e) ->
        name = e.target.value
        if @isZen(name) and name isnt ""
          @$http.post("session.json", {name: name}, csrfheader).then(
            (response) ->
              @user = response.data.name
              @status.login = true
              @checkSelf = true

            (response) -> console.log response
          )
        else
          alert "名前は全角で入力して下さい"

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
          user: @user

        @name = ""
        @desc = ""

        @$http.post("words.json", word, csrfheader).then(
          (response) -> @words.unshift response.data
          (response) -> console.log response
        )

      isZen: (str) ->
        check = true
        for i in [0...str.length]
          if escape(str.charAt(i)).length < 4
            check = false

        check
