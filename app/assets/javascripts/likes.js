$(document).on('turbolinks:load', function(){
    $('.rate .voting').on('ajax:success', function(e){
        var data = e.detail[0];
        $('.' + data.klass + '-' + data.id + ' .rating').html('rating: ' + data.rating);
    })
});