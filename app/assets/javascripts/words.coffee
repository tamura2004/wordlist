$ ->
  csrftoken = document.querySelector("meta[name=csrf-token]").content
  csrfheader = headers: "X-CSRF-Token": csrftoken

  new Vue
    el: "#app"
    data:
      sortkey: "created_at"
      sortorder: -1
      query: ""
      checkSelf: false
      status:
        login: false
      menu:
        chart: true
        rank: false
        word: false
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
      plots: []
      errors: []

    created: ->
      @setMenu("chart")

      @$http.get("/wordlist/session.json").then(
        (response) ->
          if response.data.name?
            @user = response.data.name
            @status.login = true
        (response) -> @setErrors response.data
      )


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

      dataPlot: ->
        subTotal = @plots

        users = _.uniq subTotal.map((w)->w.user)
        dates = _.uniq(subTotal.map((w)->w.date)).sort()

        # 集計用オブジェクトの初期化
        total = {}
        for user in users
          total[user] = {}
          for date in dates
            total[user][date] = 0

        userTotal = {}
        userTotal[user] = 0 for user in users

        # 集計
        for {user,date,count} in subTotal
          total[user][date] += count
          userTotal[user] += count

        # ユーザーを総登録数順に並べ替え
        users = _.toPairs(userTotal).sort((a,b)->b[1]-a[1]).map((p)->p[0])

        dataPlot = []
        for user in users
          points = []
          dateSubTotal = 0
          for date in dates
            dateSubTotal += total[user][date]
            points.push(
              {label: date.substr(5,5), y: dateSubTotal}
            )

          dataPlot.push(
            type: "line"
            lineThickness: 4
            markerSize: 12
            legendText: user
            showInLegend: true
            dataPoints: points
          )
        dataPlot

    methods:
      setErrors: (errors) ->
        alert errors.join("\n")

      clearErrors: -> @errors = []

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
        for page in ["chart","rank","word","quiz","upload"]
          @menu[page] = (name is page)
          if name is "chart"
            @$http.get("/wordlist/words/plot.json").then(
              (response) ->
                @plots = response.data
                @drawChart()
              (response) -> @setErrors response.data
            )

      drawChart: ->
        chart = new CanvasJS.Chart "chart",
          animationEnabled: true
          title:
            text: "ワード登録数"  #グラフタイトル
          theme: "theme4"  #テーマ設定
          width: 1024
          height: 480
          data: @dataPlot

        chart.render()

      filterSelf: (v)->
        not @checkSelf or v.user is @user

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
        @$http.delete("/wordlist/words/#{word.id}.json",null,csrfheader).then(
          (response) -> console.log response
          (response) -> console.log response.data
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
