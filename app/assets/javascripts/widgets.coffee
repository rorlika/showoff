# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  base_url = window.location.protocol + '//' + window.location.host
  $('#SearchSearch').searchbox
    url: base_url + '/widgets/search'
    param: 'search'
    dom_id: '#livesearch'
    loading_css: '#livesearch_loading'
  return