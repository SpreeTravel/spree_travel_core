/*
 * decaffeinate suggestions:
 * DS102: Remove unnecessary code created because of implicit returns
 * DS207: Consider shorter variations of null checks
 * Full docs: https://github.com/decaffeinate/decaffeinate/blob/master/docs/suggestions.md
 */
$(document).ready(function() {
//handle edit click
    $('a.edit-line-item').click(toggleLineItemEdit);

    //handle cancel click
    $('a.cancel-line-item').click(toggleLineItemEdit);

    //handle save click
    $('a.save-line-item').click(function() {
        let context;
        const save = $(this);
        const line_item_id = save.data('line-item-id');
        const quantity = parseInt(save.parents('tr').find('input.line_item_quantity').val());
        const product_type = save.parents('tr').find('input#product_type_' + line_item_id).val();
        const context_option_values= save.parents().find('.' + product_type + '_inputs_' + line_item_id);

        if (product_type && context_option_values) {
            context = {
                product_type
            };
            context_option_values.each((index, element) => context[element.name] = element.value);
        }

        toggleLineItemEdit();
        adjustLineItem(line_item_id, quantity, context);
        return false;
    });

    // handle delete click
    $('a.delete-line-item').click(function() {
        if (confirm(Spree.translations.are_you_sure_delete)) {
            const del = $(this);
            const line_item_id = del.data('line-item-id');

            toggleLineItemEdit();
            return deleteLineItem(line_item_id);
        }
    });

    return $('a.delete-pax').click(function() {
        if (confirm(Spree.translations.are_you_sure_delete)) {
            const del = $(this);
            const pax_id = del.data('pax-id');

            toggleLineItemEdit();
            return deletePax(pax_id);
        }
    });
});

// $('a.add-pax').click ->line_items.js
//   del = $(this);
//   line_item_id = del.data('line-item-id');

//   toggleItemEdit()
//   addPax(line_item_id)

var toggleLineItemEdit = function() {
    const link = $(this);
    link.parent().find('a.edit-line-item').toggle();
    link.parent().find('a.cancel-line-item').toggle();
    link.parent().find('a.save-line-item').toggle();
    link.parent().find('a.delete-line-item').toggle();
    link.parents('tr').find('td.line-item-qty-show').toggle();
    link.parents('tr').find('td.line-item-qty-edit').toggle();
    link.parents('tr').find('span.context-option-type-show').toggle();
    link.parents('tr').find('span.context-option-type-edit').toggle();

    return false;
};

const lineItemURL = function(line_item_id) {
    let url;
    return url = Spree.routes.orders_api + "/" + order_number + "/line_items/" + line_item_id + ".json";
};

const paxURL = function(pax_id) {
    let url;
    return url = Spree.routes.paxes_api + "/" + pax_id;
};

var adjustLineItem = function(line_item_id, quantity, context) {
    if (context == null) { context = {}; }
    const url = lineItemURL(line_item_id);
    return $.ajax({
        type: "PUT",
        url: Spree.url(url),
        data: {
            line_item: {
                quantity,
                context
            },
            token: Spree.api_key
        }
    }).done(msg => window.Spree.advanceOrder());
};

var deleteLineItem = function(line_item_id) {
    const url = lineItemURL(line_item_id);
    return $.ajax({
        type: "DELETE",
        url: Spree.url(url),
        data: {
            token: Spree.api_key
        }
    }).done(function(msg) {
        $('#line-item-' + line_item_id).remove();
        if ($('.line-items tr.line-item').length === 0) {
            $('.line-items').remove();
        }
        return window.Spree.advanceOrder();
    });
};

var deletePax = function(pax_id) {
    const url = paxURL(pax_id);
    return $.ajax({
        type: "DELETE",
        url: Spree.url(url),
        data: {
            token: Spree.api_key
        }
    }).done(function(msg) {
        $('pax-' + pax_id).remove();
        return window.Spree.advanceOrder();
    });
};