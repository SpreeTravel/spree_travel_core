//= require store/spree_frontend
//= require store/underscore

$(document).ready(function() {
   list = $('.ajax-price');
    $.each(list, function(index, object) {
        object = $(object);
        product_id = object.attr('data-product-hook');
        $.ajax({
          data_type: 'JSON',
          data: {product_id: product_id},
          type: 'POST',
          url: '/products/get_ajax_price',
          success: function (result) {
            object.html(result);
          },
          error: function() {
            object.html('ERROR');
          }
        });
    });
});
