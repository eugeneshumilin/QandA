App.cable.subscriptions.create('QuestionsChannel', {
  connected: ->
    @perform 'follow'
  ,

  received: (data) ->
    new_question = $.parseJSON(data)

    if gon.current_user.id != new_question.user.id
      $('.questions').append(JST['templates/question']({ question: new_question } ))
})
