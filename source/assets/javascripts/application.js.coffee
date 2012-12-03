#= require libs/jquery.min
#= require libs/jquery.gridster.min
#= require libs/quantize
#= require libs/color-thief

#= require colors
#= require events

initGridster = ->
  margin = 10
  cols = 6
  width = ($('.gridster').width() / cols) - (2 * margin)

  $(".gridster ul").gridster
    widget_margins: [margin, margin]
    widget_base_dimensions: [width, width]
    max_size_y: cols


$ ->
  initGridster()
