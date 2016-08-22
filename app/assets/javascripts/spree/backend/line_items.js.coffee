$(document).ready ->
#handle edit click
  $('a.edit-line-item').click toggleLineItemEdit

  #handle cancel click
  $('a.cancel-line-item').click toggleLineItemEdit

  #handle save click
  $('a.save-line-item').click ->
    save = $ this
    line_item_id = save.data('line-item-id')
    quantity = parseInt(save.parents('tr').find('input.line_item_quantity').val())
    product_type = save.parents('tr').find('input#product_type_' + line_item_id).val()
    context_option_values= save.parents().find('.' + product_type + '_inputs')

    if product_type && context_option_values
      context = {
        product_type: product_type
      };
      context_option_values.each (index, element) ->
        context[element.id] = element.value;

    toggleItemEdit()
    adjustLineItem(line_item_id, quantity, context)
    false

  # handle delete click
  $('a.delete-line-item').click ->
    if confirm(Spree.translations.are_you_sure_delete)
      del = $(this);
      line_item_id = del.data('line-item-id');

      toggleItemEdit()
      deleteLineItem(line_item_id)

  $('a.delete-pax').click ->
    if confirm(Spree.translations.are_you_sure_delete)
      del = $(this);
      pax_id = del.data('pax-id');

      toggleItemEdit()
      deletePax(pax_id)

  $('a.add-pax').click ->
    del = $(this);
    line_item_id = del.data('line-item-id');

    toggleItemEdit()
    addPax(line_item_id)

toggleLineItemEdit = ->
  link = $(this);
  link.parent().find('a.edit-line-item').toggle();
  link.parent().find('a.cancel-line-item').toggle();
  link.parent().find('a.save-line-item').toggle();
  link.parent().find('a.delete-line-item').toggle();
  link.parents('tr').find('td.line-item-qty-show').toggle();
  link.parents('tr').find('td.line-item-qty-edit').toggle();
  link.parents('tr').find('span.context-option-type-show').toggle();
  link.parents('tr').find('span.context-option-type-edit').toggle();

  false

lineItemURL = (line_item_id) ->
  url = Spree.routes.orders_api + "/" + order_number + "/line_items/" + line_item_id + ".json"

paxURL = (pax_id) ->
  url = Spree.routes.paxes_api + "/" + pax_id
  
adjustLineItem = (line_item_id, quantity, context={}) ->
  url = lineItemURL(line_item_id)
  $.ajax(
    type: "PUT",
    url: Spree.url(url),
    data:
      line_item:
        quantity: quantity
        context: context
      token: Spree.api_key
  ).done (msg) ->
    window.Spree.advanceOrder()

deleteLineItem = (line_item_id) ->
  url = lineItemURL(line_item_id)
  $.ajax(
    type: "DELETE"
    url: Spree.url(url)
    data:
      token: Spree.api_key
  ).done (msg) ->
    $('#line-item-' + line_item_id).remove()
    if $('.line-items tr.line-item').length == 0
      $('.line-items').remove()
    window.Spree.advanceOrder()

deletePax = (pax_id) ->
  url = paxURL(pax_id)
  $.ajax(
    type: "DELETE"
    url: Spree.url(url)
    data:
      token: Spree.api_key
  ).done (msg) ->
    $('pax-' + pax_id).remove()
    window.Spree.advanceOrder()