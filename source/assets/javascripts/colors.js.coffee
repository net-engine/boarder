@sum = (array) ->
  sum = 0
  $.each array, (i, num) ->
    sum += parseInt(num) or 0
  sum

@mean = (array) ->
  sum(array) / array.length

@median = (array) ->
  array.sort (a, b) ->
    a - b

  half = Math.floor(array.length / 2)
  if array.length % 2
    array[half]
  else
    (array[half - 1] + array[half]) / 2.0

@mode = (array) ->
  return null  if array.length is 0
  modeMap = {}
  maxEl = array[0]
  maxCount = 1
  i = 0

  while i < array.length
    el = array[i]
    unless modeMap[el]?
      modeMap[el] = 1
    else
      modeMap[el]++
    if modeMap[el] > maxCount
      maxEl = el
      maxCount = modeMap[el]
    i++
  maxEl


@RGBify = (color) ->
  return 'rgb(' + color.join(', ') + ')'

@RGBAify = (color, opacity) ->
  return 'rgba(' + color.join(', ') + ', ' + parseFloat(number) + ')'

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

  averageColor = [Math.round(median(red)), Math.round(median(green)), Math.round(median(blue))]
  return averageColor

@updateColor = (color) ->
  $('body').css
    'background': RGBify(color)
    'color': RGBify(inverseColor(color))
  $('a').css
    'color': RGBify(inverseColor(color))

