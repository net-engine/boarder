Template.boards.helpers
  boards: ->
    Boards.find()

Template.board.events
  'click .icon-delete': (e, tmpl) ->
    e.preventDefault()
    Boards.remove(@_id)

Template.boards.rendered = ->
  Session.get("layout")
  
  initGridster = ->
    margin = 10
    cols = 6
    gridWidth = 100

    @gridster = $(".boards").gridster(
      widget_margins: [margin, margin]
      widget_base_dimensions: [gridWidth, gridWidth]
      max_size_y: cols

    ).data("gridster")

  initGridster()

Template.authenticated.rendered = ->
  Session.set('Meteor.loginButtons.dropdownVisible', false)

Template.public.rendered = ->
  Session.set('Meteor.loginButtons.dropdownVisible', true)


# Boards.update(Boards.findOne()._id, {$set: {name: 'hello again', updated_at: new Date()}})