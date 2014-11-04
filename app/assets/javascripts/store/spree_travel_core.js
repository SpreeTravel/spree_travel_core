//= require spree/frontend
//= require store/tab
//= require store/underscore
//= require store/cart_overlay
//= require store/datepicker
//= require jquery-ui/datepicker

var unavailable_products_visibles = true;

function params_data(product_id) {
    product_type = $('ul#search_box_tabs li.active a')[0].name;
    data = {
	   product_id: product_id,
	   product_type: product_type,
    };

    inputs = $('.' + product_type + '_inputs');
    inputs.each(function(index, element) {
	   data[element.id] = element.value;
    });

    selects = $('.' + product_type + '_selects');
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
        console.debug('getting price for' + product_id);
        $.ajax({
            data_type: 'JSON',
            data: params_data(product_id),
            type: 'POST',
            url: '/products/get_ajax_price',
            success: function (result) {
              if (result.variant == "none") {
                b = $('#add-to-cart-button' + '_' + result.product_id);
                selector = "ul#products li#product_"+ result.product_id
                b.attr('disabled', true);
                b.addClass('disabled');
                object.html('No options available.');
                if (!unavailable_products_visibles) {
                    $(selector).css('display', 'none')
                }
              } else {
                selector = "ul#products li#product_"+ result.product_id
                prices = result.prices
                object.html(prices);
                hidden_id = "#vp_" + product_id;
                $(hidden_id).val(result.variant);
                $(selector).css('display', 'inherit')
                b = $('#add-to-cart-button' + '_' + result.product_id);
                if (prices.indexOf('Starting') != -1 || prices == "") {
                  b.attr('disabled', true);
                  b.addClass('disabled');
                  if (!unavailable_products_visibles) {
                    $(selector).css('display', 'none')
                  }
                } else {
                  b.attr('disabled', false);
                  b.removeClass('disabled');
                  $(selector).css('display', 'inherit')
                }
              };
            },
            error: function() {
              b = $('#add-to-cart-button' + '_' + result.product_id);
              selector = "ul#products li#product_"+ result.product_id
              b.attr('disabled', true);
              b.attr('hidden', true);
              b.addClass('disabled');
		          object.html('ERROR');
              if (!unavailable_products_visibles) {
                $(selector).css('display', 'none')
              }
            }
        });
    });
    return false;
}

function fill_cart_hiddens(product_id) {
    template = $('#template-hidden');
    console.log(template);
    data = params_data(product_id);
    theform = $('#inside-product-cart-form');
    $.each(data, function(index, val) {
        index_name = index + "_cart_form";
        console.log(index_name);
        new_hidden = $('#'+index_name, theform);
        if (new_hidden.length == 0) {
            new_hidden = template.clone();
            new_hidden.attr('name', index);
            new_hidden.attr('id', index_name);
            console.log(new_hidden);
            theform.append(new_hidden);
        }
        new_hidden.val(val);
    });
    console.log('#######################################');
}

function available_visibility_changed(){
    unavailable_products_visibles = !unavailable_products_visibles;
    update_prices();
}

$(document).ready(function() {
    update_prices();
    $('#update_price').attr('onclick', 'update_prices()');
    $('.visibility_check_box').attr('onclick', 'available_visibility_changed()');
});
