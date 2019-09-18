# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$(document).on('turbolinks:load', ->
  $(document).bind 'ajax:error', (e) ->
    [data, status, xhr] = e.detail;
    flash = $('.flash')

    switch (xhr.status)
      when 401
        flash.html('You need to sign in or sign up before continuing.')
      when 403
        flash.html('You are not authorized to access this page.')
)