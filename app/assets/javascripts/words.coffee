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
      @$http.get "http://localhost:3000/words.json", (data,status,request) ->
        @words.push word for word in data
        document.getElementById("new_word").focus()

    methods:
      remove: (word) ->
        word.removed = true

      insert: ->
        document.getElementById("new_word").focus() # 何故かこれをしないとdescがクリアされない
        word =
          name: @name.replace(/\n/g,"")
          desc: @desc.replace(/\n/g,"")

        @name = ""
        @desc = ""

        @$http.post "http://localhost:3000/words.json", word, (data,status,request) ->
          @words.unshift data