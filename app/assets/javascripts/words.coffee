# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$ ->
  new Vue
    el: "#app"
    data:
      name: ""
      desc: ""
      words: []

    created: ->
      @$http.get "words.json", (data,status,request) ->
        @words.unshift word for word in data
        # document.getElementById("new").firstElementChild.focus()

    methods:
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