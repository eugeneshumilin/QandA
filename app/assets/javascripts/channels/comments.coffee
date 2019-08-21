$ ->
  questionId = $(".question-item").data("id")

  App.cable.subscriptions.create({ channel: 'CommentsChannel', question_id: questionId }, {
    connected: ->
      @perform 'follow'
    ,
    received: (data) ->
      dataParse = $.parseJSON(data)

      comment = dataParse.comment
      container = '.' + comment.commentable_type.toLowerCase() + '-' + comment.commentable_id

      if gon.current_user && (gon.current_user.id != comment.user_id)
        $(container + ' .comments').append(JST['templates/comment']({
          comment: comment,
          user_email: dataParse.user_email
        } ))
  })