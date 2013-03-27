Meteor.startup ->
  # code to run on server at startup

Meteor.methods
  sendEmail: (to, from, subject, text, html) ->
    # Let other method calls from the same client start running, without waiting for the email sending to complete.
    @unblock()

    Email.send
      to: to
      from: from
      subject: subject
      text: text
      html: html