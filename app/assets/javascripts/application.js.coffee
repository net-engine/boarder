#= require libs/jquery.min
#= require libs/jquery.gridster.min
#= require libs/jquery-ui.min
#= require libs/quantize
#= require libs/color-thief

#= require colors
#= require_tree './templates'

settings = 'layout'
gridsterContainer = $('.gridster ul')

initResizable = ->
  $('.gridster li').resizable
    grid: ($('.gridster').width() / 6) - 20

refresh = ->
  setTimeout (->
    $('.gridster').remove()
    $('#main').append('<div class="gridster"><ul></ul></div>')
    loadGrid()
  ), 100

@saveSettings = ->
  blocks = []
  items = $('.gridster ul').find('li')
  count = items.length

  if count isnt 0
    items.each (i, el) ->
      $this = $(this)

      count--

      newObj = $this.data()
      delete newObj.coords
      newObj.image = $this.find('img').attr('src')
      blocks.push newObj

      if count is 0
        # delete blocks[blocks.length - 1]
        localStorage.setItem(settings, JSON.stringify(blocks))
        $('#resize-dialog').remove()

        refresh()
  else
    refresh()

@loadGrid = ->
  if localStorage.getItem(settings)
    blocks = JSON.parse localStorage.getItem(settings)
    count = blocks.length

    # $('body').addClass 'loading'

    $.each blocks, (i, block) ->
      $('.gridster ul').append JST["templates/block"](block) if i < blocks.length
      count--

      if count is 0
        initGridster()
        

        $(window).load ->
          # $('body').removeClass 'loading'

          # updateColor averageColours(getColors())
          # This is currently broken due to cross origin issues when serving the images from imgur

  else
    $('#main').addClass('empty')
    initGridster()


@initGridster = ->
  margin = 10
  cols = 6
  gridWidth = ($('.gridster').width() / cols) - (2 * margin)

  @gridster = $(".gridster ul").gridster(
    widget_margins: [margin, margin]
    widget_base_dimensions: [gridWidth, gridWidth]
    max_size_y: cols
    draggable:
      stop: (event, ui) ->
        setTimeout (->
          saveSettings()
        ), 500

  ).data("gridster")
  maintainAspect('.gridster ul li img', true)
  # initResizable()

maintainAspect = (elem, centre) ->
  $(elem).each (i, e) ->
    img = $(e)
    (img).load( -> 
      ratio = img.width() / img.height()
      if img.width() < img.parent().width()
        img.addClass 'tall'
        nh = parseInt img.width()/ratio
        img.css 'max-height', nh
        if centre
          img.css 'margin-top', (img.parent().height() - nh)/2
      else
        img.addClass 'wide'
        nw = parseInt img.height()*ratio
        img.css 'max-width', nw
        if centre 
          img.css 'margin-left', (img.parent().width() - nw)/2
    )

upload = (file) ->
  APIKey = "4a49972bdbbcb16572a430007f806211"

  return  if not file or not file.type.match(/image.*/)
  $('body').attr('class', 'uploading')

  fd = new FormData()
  fd.append "image", file
  fd.append "key", APIKey

  xhr = new XMLHttpRequest()
  xhr.open "POST", "http://api.imgur.com/2/upload.json"
  xhr.onload = ->

    # The URL of the image is:
    image = JSON.parse(xhr.responseText)
    src = image.upload.links.original
    # console.log image
    # console.log src

    $('#main').removeClass('empty')
    initGridster()
    gridster.add_widget('<li><img src="' + src + '"><div class="item-actions"><a class="resize item-action icon-resize" href="#resize">Resize</a><a class="close item-action icon-close" href="#remove">Remove</a></div></li>', 1, 1, 1, 1)

    $('body').attr('class', 'uploaded')

    saveSettings()

    # updateColor averageColours(getColors())

  xhr.send fd

$ ->
  loadGrid()

  $(window).resize ->
    refresh()

  $(document).on "change", 'input[type="color"]', (e) ->
    updateColor hex2rgb $(this).val()

  window.ondrop = (e) ->
    e.preventDefault()
    upload e.dataTransfer.files[0]

  $(document).on "change", '#file-upload', (e) ->
    upload this.files[0]

  $(document).on "click", "#add-button", (e) ->
    $('#file-upload').click()

  $(document).on "click", "#save-button", (e) ->
    e.preventDefault()
    $("#save-dialog textarea").val localStorage.getItem(settings)
    $("#save-dialog").toggleClass('hidden')
    $("#upload-dialog").addClass('hidden')

  $(document).on 'click', '#display-button', (e) ->
    $('body').toggleClass 'display'

  $(document).on "click", "#upload-button", (e) ->
    e.preventDefault()
    $("#upload-dialog").toggleClass('hidden')
    $("#save-dialog").addClass('hidden')

  $(document).on "click", "#upload-save-button", (e) ->
    e.preventDefault()
    try
      jsonText = $.parseJSON($('#load-box').val())
    catch e
      alert "Hey! That's not JSON :("

    localStorage.setItem(settings, jsonText)
    saveSettings()

  $(document).on "click", ".gridster .close", (e) ->
    e.preventDefault()
    gridster.remove_widget
    gridster.remove_widget $(this).closest("li"), ->
      saveSettings()

    # updateColor(averageColours(getColors()))

  $(document).on 'click', '.gridster .resize', (e) ->
    li = $(this).closest('li')
    e.preventDefault()
    if $.contains(li, '#resize-dialog') and $('#resize-dialog').is(':visible')
      $('#resize-dialog').remove()
    else
      li.append('<div id="resize-dialog" class="dialog"><input type="number" id="size-x" placeholder="Width"><input type="number" id="size-y" placeholder="Height"><a id="resize-dialog-save" class="button save-button" href="#save">Save</a></div>')

  $(document).on 'click', '#resize-dialog-save', (e) ->
    e.preventDefault()
    inputSizeX = $("#size-x")
    inputSizeY = $("#size-y")
    if inputSizeX.val().length isnt 0 then sizeX = parseInt(inputSizeX.val()) else sizeX = parseInt(inputSizeX.closest("li").attr("data-sizex"))
    if inputSizeY.val().length isnt 0 then sizeY = parseInt(inputSizeY.val()) else sizeY = parseInt(inputSizeY.closest("li").attr("data-sizey"))
    gridster.resize_widget($(this).closest('li'), sizeX, sizeY)
    saveSettings()


