refreshPage = ->
  setTimeout (->
    window.location.replace(window.location.href)
  ), 100

saveSettings = ->
  blocks = []
  items = $('.gridster ul').find('li')
  count = items.length

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
      refreshPage()

loadGrid = ->
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

          # This is currently broken due to cross origin issues when serving the images from imgur
          # updateColor averageColours(getColors())
  else
    $('#main').addClass('empty')


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

    $('img').load ->
      $('body').removeClass()
      saveSettings()
      # updateColor averageColours(getColors())

  xhr.send fd
