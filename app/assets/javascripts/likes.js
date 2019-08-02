$(document).on('turbolinks:load', function(){
    $('.rate .voting').on('ajax:success', function(e){
        var data = e.detail[0];
        var voteClass = '.' + data.klass + '-' + data.id
        $(voteClass + ' .rating').html('rating: ' + data.rating);
        $(voteClass + ' .cancel-vote-link').removeClass('hidden');
        $(voteClass + ' .voting').addClass('hidden');
    })

    $('.re-vote').on('ajax:success', function(e){
        var data = e.detail[0];
        var voteClass = '.' + data.klass + '-' + data.id
        $(voteClass + ' .rating').html('rating: ' + data.rating);
        $(voteClass + ' .cancel-vote-link').addClass('hidden');
        $(voteClass + ' .voting').removeClass('hidden');
    })
});