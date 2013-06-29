Template.boards.helpers
  boards: ->
    Boards.find()

Template.boards.events
  'click #new-board-button': (e, tmpl) ->
    e.preventDefault()
    $('#new-board-dialog').show()

  'click .close-dialog': (e, tmpl) ->
    e.preventDefault()
    $(e.target).closest('.dialog').hide()

  'click #new-board-submit': (e, tmpl) ->
    e.preventDefault()
    
    Boards.insert
      title: $('#new-board-title').val()
      content: $('#new-board-content').val()

    $('#new-board-dialog').hide()
    $('#new-board-title').val('')
    $('#new-board-content').val('')

  'click #edit-board-submit': (e, tmpl) ->
    e.preventDefault()

    if editing_id?
      Boards.update editing_id,
        $set:
          title: $('#edit-board-title').val()
          content: $('#edit-board-content').val()
          updated_at: new Date()

      $('#edit-board-dialog').hide()
      $('#edit-board-title').val('')
      $('#edit-board-content').val('')
      window.editing_id = null

Template.board.events
  'click .icon-delete': (e, tmpl) ->
    e.preventDefault()
    Boards.remove(@_id)

  'dblclick .board': (e, tmpl) ->
    $('#edit-board-title').val(@title)
    $('#edit-board-content').val(@content)

    window.editing_id = @_id

    $('#edit-board-dialog').show()


Template.boards.rendered = ->
  Session.get("layout")
  
  # initGridster = ->
  #   margin = 10
  #   cols = 6
  #   gridWidth = 100

  #   @gridster = $(".boards").gridster(
  #     widget_margins: [margin, margin]
  #     widget_base_dimensions: [gridWidth, gridWidth]
  #     max_size_y: cols

  #   ).data("gridster")

  # initGridster()

Template.authenticated.rendered = ->
  Session.set('Meteor.loginButtons.dropdownVisible', false)

Template.public.rendered = ->
  Session.set('Meteor.loginButtons.dropdownVisible', true)
