//= require store/spree_frontend
//= require store/underscore
//= require store/cart_overlay
//= require store/datepicker
//= require jquery.ui.datepicker

function update_prices() {
   list = $('.ajax-price');
    $.each(list, function(index, object) {
        object = $(object);   
        object.html('<img src="/assets/ajax-loader.gif" >');
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
    return false;
}

$(document).ready(function() {
  update_prices();
  $('#update_price').attr('onclick', 'update_prices()');
});
