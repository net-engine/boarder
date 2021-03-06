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

@hex2rgb = (hex) ->
  hex = hex.substr(1)  if hex[0] is "#"
  if hex.length is 3
    temp = hex
    hex = ""
    temp = /^([a-f0-9])([a-f0-9])([a-f0-9])$/i.exec(temp).slice(1)
    i = 0

    while i < 3
      hex += temp[i] + temp[i]
      i++
  triplets = /^([a-f0-9]{2})([a-f0-9]{2})([a-f0-9]{2})$/i.exec(hex).slice(1)
  [parseInt(triplets[0], 16), parseInt(triplets[1], 16), parseInt(triplets[2], 16)]


@RGBify = (color) ->
  c = for n, chan of color
    chan
  return 'rgb(' + c.join(', ') + ')'

@RGBAify = (color, opacity) ->
  return 'rgba(' + c.join(', ') + ', ' + parseFloat(number) + ')'

@inverseColor = (color) ->
  c = for n, chan of color
      255 - chan
  return 'rgb(' + c.join(', ') + ')'

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
  console.log(RGBify(color))
  $('body').css
    'background': RGBify(color)
    'color': inverseColor(color)
  $('a').css
    'color': inverseColor(color)

# $ ->
#   ColorPicker.fixIndicators(document.getElementById('slider-indicator'),document.getElementById('picker-indicator'))
#   ColorPicker(document.getElementById('slider'), document.getElementById('picker'), (hex, hsv, rgb, pickerCoordinate, sliderCoordinate) ->
#     ColorPicker.positionIndicators(document.getElementById('slider-indicator'), document.getElementById('picker-indicator'), sliderCoordinate, pickerCoordinate)
#     updateColor(rgb)
#   )
