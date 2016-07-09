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
        show: 14
        move: 10
        current: 0
        max: 0
      user: ""
      username: ""
      name: ""
      desc: ""
      words: []

    created: ->
      @$http.get("/wl/words.json").then(
        (response) -> @words = response.data
        (response) -> console.log response
      )

      @$http.get("/wl/session.json").then(
        (response) ->
          if response.data.name?
            @user = response.data.name
            @status.login = true
        (response) -> console.log response
      )

      @$http.get("/wl/words/count.json").then(
        (response) ->
          @page.max = Math.ceil(response.data.count/@page.move)

        (response) -> console.log response
      )

      document.getElementById("new").firstElementChild.focus()

    computed:
      totalRank: -> _.countBy @words, "user"
      monthlyRank: -> _.countBy @words, "user"
      weeklyRank: -> _.countBy @words, "user"
      pos: -> @page.current * @page.move

    methods:
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
          "#{Math.floor(200/(str.length))}px"
        else
          "24px"

      update: (word)->
        @$http.patch("/wl/words/#{word.id}.json",word,csrfheader).then(
          (response) -> console.log response
          (response) -> console.log response
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
          @$http.post("/wl/session.json", {name: @username}, csrfheader).then(
            (response) ->
              @user = response.data.name
              @status.login = true
              @checkSelf = true

            (response) -> console.log response
          )
        else
          alert "名前は全角で入力して下さい"

      remove: (word) ->
        @$http.patch("/wl/words/#{word.id}.json",{removed:true},csrfheader).then(
          (response) -> console.log response
          (response) -> console.log response
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

        @$http.post("/wl/words.json", word, csrfheader).then(
          (response) -> @words.unshift response.data
          (response) -> console.log response
        )

      isZen: (str) ->
        check = true
        for i in [0...str.length]
          if escape(str.charAt(i)).length < 4
            check = false

        check
