$ ->
  csrftoken = document.querySelector("meta[name=csrf-token]").content
  csrfheader = headers: "X-CSRF-Token": csrftoken

  new Vue
    el: "#app"
    data:
      sortkey: "created_at"
      sortorder: -1
      query: ""
      filter: "all"
      checkSelf: false
      status:
        login: false
      menu:
        rank: false
        word: true
        quiz: false
        upload: false
      page:
        show: 50
        move: 50
        current: 0
        max: 0
      user: ""
      username: ""
      name: ""
      desc: ""
      words: []
      errors: []

    created: ->
      @$http.get("/wordlist/words.json").then(
        (response) -> @words = response.data
        (response) -> @setErrors response.data
      )

      @$http.get("/wordlist/session.json").then(
        (response) ->
          if response.data.name?
            @user = response.data.name
            @status.login = true
        (response) -> @setErrors response.data
      )

      @$http.get("/wordlist/words/count.json").then(
        (response) ->
          @page.max = Math.ceil(response.data.count/@page.move) - 1

        (response) -> @setErrors response.data
      )

      document.getElementById("new").firstElementChild.focus()

    computed:
      totalRank: -> _.countBy @words, "user"
      monthlyRank: ->
        monthBefore = (
          new Date(new Date().getTime() - 30*24*3600*1000)
        ).toISOString()

        _.countBy (
          _.filter @words, (w) ->
            monthBefore < w.updated_at
        ), "user"

      weeklyRank: ->
        weekBefore = (
          new Date(new Date().getTime() - 7*24*3600*1000)
        ).toISOString()

        _.countBy (
          _.filter @words, (w) ->
            weekBefore < w.updated_at
        ), "user"

      pos: -> @page.current * @page.move

    methods:
      setErrors: (errors) ->
        alert errors.join("\n")

      clearErrors: -> @errors = []

      isEllipsis: (p) ->
        (p is 3 and 6 <= @page.current) or (p is @page.max - 3 and @page.current <= @page.max - 6)

      inRange: (p) ->
        p < 3 or @page.max - 3 < p or (@page.current - 3 < p and p < @page.current + 3)

      isCurrent: (p)->
        @page.current is p

      gotopage: (p)-> @page.current = p
      prevpage: -> @page.current -= 1 if @page.current > 0
      nextpage: -> @page.current += 1 if @page.current < @page.max
      toppage: -> @page.current = 0
      lastpage: -> @page.current = @page.max

      autosize: (str)->
        if str.length > 7
          "#{Math.floor(180/(str.length))}px"
        else
          "24px"

      update: (word)->
        @$http.patch("/wordlist/words/#{word.id}.json",word,csrfheader).then(
          (response) -> console.log response
          (response) -> @setErrors response.data
        )

      setMenu: (name)->
        for page in ["rank","word","quiz","upload"]
          @menu[page] = (name is page)

      filterSelf: (v)->
        not @checkSelf or v.user is @user

      filterCustom: (v) ->
        @filter is "all" or (@filter is "num" and v.name.match(/^[0-9]+$/)) or (@filter is "nodesc" and v.desc is null)

      logoff: ->
        @user = ""
        @status.login = false
        @checkSelf = false

      login: ->
        if @isZen(@username) and @username isnt ""
          @$http.post("/wordlist/session.json", {name: @username}, csrfheader).then(
            (response) ->
              @user = response.data.name
              @status.login = true
              @checkSelf = true

            (response) -> console.log response
          )
        else
          alert "名前は全角で入力して下さい"

      remove: (word) ->
        @$http.patch("/wordlist/words/#{word.id}.json",{removed:true},csrfheader).then(
          (response) -> console.log response
          (response) -> @setErrors response.data
        )
        @words = _.filter @words, (w) -> w.id isnt word.id

      focusNext: (e) -> e.target.nextElementSibling.focus()

      onEnter: (e) ->
        t = e.target
        switch t.className
          when "item-title"
            t.nextElementSibling.focus() if t.value isnt ""

          when "item-body"
            @insert()
            t.previousElementSibling.focus()

      insert: ->
        document.getElementById("new").firstElementChild.focus()
        word =
          name: @name.replace(/\n/g,"")
          desc: @desc.replace(/\n/g,"")
          user: @user

        @name = ""
        @desc = ""

        @$http.post("/wordlist/words.json", word, csrfheader).then(
          (response) -> @words.unshift response.data
          (response) -> @setErrors response.data
        )

      isZen: (str) ->
        check = true
        for i in [0...str.length]
          if escape(str.charAt(i)).length < 4
            check = false

        check
