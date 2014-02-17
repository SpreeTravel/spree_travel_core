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
          data: {
	      product_id: product_id,
	      taxon: 'Hotel', // TODO: coger el taxon del tab activo
	      start_date: document.getElementById('start_date').value,
	      end_date: document.getElementById('end_date').value,
	      adult: document.getElementById('adult').value,
	      child: document.getElementById('child').value,
	      room: document.getElementById('room').value,
	      plan: document.getElementById('plan').value,
	  },
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
