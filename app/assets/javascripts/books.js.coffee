# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  console.log "books.js#init"
  $('#new_search_form').on 'ajax:success', (e, books) ->
    console.log books
    $('tr.book').hide()
    ids = (books.map (b) -> "#book_#{b.id}").join(",")
    $(ids).show()
