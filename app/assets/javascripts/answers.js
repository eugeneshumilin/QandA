$(document).on('turbolinks:load', function(){
    $('.answers').on('click', '.edit-answer-link', function(e){
        e.preventDefault();
        $(this).hide();
        var answerId = $(this).data('answerId');
        $('form#edit-answer-' + answerId).removeClass('hidden');
    })
});


$(document).on('turbolinks:load', function(){
    $('.answers').on('click', '.best-answer-link', function(e){
        var answerId = $(this).data('answerId');
        $('div.answer-' + answerId).addClass('best-answer');
    })
});