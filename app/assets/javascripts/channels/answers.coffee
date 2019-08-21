$ ->
  questionId = $(".question-item").data("id")

  App.cable.subscriptions.create({ channel: 'AnswersChannel', question_id: questionId }, {
    connected: ->
      @perform 'follow'
    ,
    received: (data) ->
      parseData = $.parseJSON(data)
      console.log(parseData)

      if gon.current_user && (gon.current_user.id != parseData.answer.user_id)
        $('.answers').append(JST['templates/answer']({
          answer: parseData.answer,
          files: parseData.files,
          links: parseData.links,
          rating: parseData.rating
      }))
  })
