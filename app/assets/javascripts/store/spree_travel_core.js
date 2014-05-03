//= require store/spree_frontend
//= require store/tab
//= require store/underscore
//= require store/cart_overlay
//= require store/datepicker
//= require jquery.ui.datepicker

// TODO: poner una clase en los elementos de busqueda y cambiar la busqueda
// por inputs a busqueda por clase
function params_data(product_id) {
    product_type = $('ul#search_box_tabs li.active a')[0].name;
    data = {
	product_id: product_id,
	product_type: product_type,
    };
    inputs = $('div#' + product_type + '_fields ul li input');
    inputs.each(function(index, element) {
	data[element.id] = element.value;
    });
    selects = $('div#' + product_type + '_fields ul li select');
    selects.each(function(index, element) {
	data[element.id] = element.value;
    });
    return data
}

function update_prices() {
    list = $('.ajax-price');
    $.each(list, function(index, object) {
        object = $(object);
        object.html('<img src="/assets/ajax-loader.gif" >');
        product_id = object.attr('data-product-hook');
        $.ajax({
            data_type: 'JSON',
            data: params_data(product_id),
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
