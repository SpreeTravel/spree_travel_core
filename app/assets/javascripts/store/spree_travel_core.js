//= require spree/frontend
//= require store/tab
//= require store/underscore
//= require store/cart_overlay
//= require store/datepicker
//= require jquery-ui/datepicker

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
        fill_cart_hiddens(product_id);
        $.ajax({
            data_type: 'JSON',
            data: params_data(product_id),
            type: 'POST',
            url: '/products/get_ajax_price',
            success: function (result) {
              console.debug(result);
              if (result.prices.length == 0) {
                b = $('#add-to-cart-button' + '_' + result.product_id);
                b.attr('disabled', true);
                b.addClass('disabled');
                object.html('No prices available');
              } else {
                prices = result.prices
                prices_str = "" + prices[0] + " .. " + prices[prices.length-1];
                object.html(prices_str);
                hidden_id = "#vp_" + product_id;
                $(hidden_id).val(result.variant);
                b = $('#add-to-cart-button' + '_' + result.product_id);
                if (prices.length == 0) {
                  b.attr('disabled', true);
                  b.addClass('disabled');
                } else {
                  b.attr('disabled', false);
                  b.removeClass('disabled');
                }
              };
            },
            error: function() {
              b = $('#add-to-cart-button' + '_' + result.product_id);
              b.attr('disabled', true);
              b.attr('hidden', true);
              b.addClass('disabled');
		      object.html('ERROR');
            }
        });
    });
    return false;
}

function fill_cart_hiddens(product_id) {
    theform = $('#inside-product-cart-form-'+product_id);
    template = $('#template-hidden-'+product_id, theform);
    data = params_data(product_id);
    $.each(data, function(index, val) {
        index_name = index + "_cart_form";
        new_hidden = $('.'+index_name, theform);
        if (new_hidden.length == 0) {
            new_hidden = template.clone();
            new_hidden.attr('name', index);
            new_hidden.attr('class', index_name);
            new_hidden.attr('id', index_name + '_' + product_id);
            theform.append(new_hidden);
        }
        new_hidden.val(val);
    });
}


$(document).ready(function() {
    update_prices();
    $('#search_box_tabs li a').on('click', function(event) {
        var v = $(event.target).attr('name');
        $('#the_product_type').val(v);
    });
    $('#update_price').attr('onclick', 'update_prices()');
});
