@sum = (arr) ->
  sum = 0
  $.each arr, (i, num) ->
    sum += parseInt(num) or 0

  sum

@avgAndRound = (arr) ->
  Math.round sum(arr) / arr.length

@RGBify = (color) ->
  return 'rgb(' + color.join(', ') + ')'

@inverseColor = (color) ->
  inverseColor = []

  $.each color, (i, num) ->
    inverseColor.push 255 - num

  return inverseColor

@getColors = ->
  colors = []
  $("img").each ->
    $img = $(this)
    colors.push getDominantColor($img)

  return colors

@averageColours = (colors) ->
  red = []
  green = []
  blue = []

  $.each colors, (i, colour) ->
    $.each colour, (i, num) ->
      if i is 0
        red.push num
      else if i is 1
        green.push num
      else blue.push num  if i is 2

  averageColor = [avgAndRound(red), avgAndRound(green), avgAndRound(blue)]
  return averageColor

@updateColor = (color) ->
  $('body').css
    'background': RGBify(color)
    'color': RGBify(inverseColor(color))
  $('a').css
    'color': RGBify(inverseColor(color))

$ ->


  $(window).load ->

    updateColor averageColours(getColors())

