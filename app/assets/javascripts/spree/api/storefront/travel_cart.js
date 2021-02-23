//= require spree/api/main

SpreeAPI.Storefront.travelAddToCart = function (variantId, quantity, productType, rateId, productId, context_options, options, successCallback, failureCallback) {
    let params = {
        variant_id: variantId,
        quantity: quantity,
        product_type: productType,
        rate_id: rateId,
        product_id: productId,
        price: price,
        options: options
    };
    $.extend(params, context_options);
  fetch(Spree.routes.api_v2_storefront_cart_add_item, {
    method: 'POST',
    headers: SpreeAPI.prepareHeaders({ 'X-Spree-Order-Token': SpreeAPI.orderToken }),
    body: JSON.stringify(params)
  }).then(function (response) {
    switch (response.status) {
      case 422:
        response.json().then(function (json) { failureCallback(json.error) })
        break
      case 500:
        SpreeAPI.handle500error()
        break
      case 200:
        response.json().then(function (json) {
            successCallback(json.data)
        })
        break
    }
  })
}
