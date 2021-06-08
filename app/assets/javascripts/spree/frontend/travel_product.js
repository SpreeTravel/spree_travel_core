//= require spree/api/storefront/travel_cart
//= require spree/frontend/cart

Spree.ready(function ($) {
  Spree.addImageHandlers = function () {
    var thumbnails = $("#product-images ul.thumbnails");

    ($("#main-image")).data("selectedThumb", ($("#main-image img")).attr("src"));

    thumbnails
      .find("li")
      .eq(0)
      .addClass("selected")
      .find('img')
      .addClass('border-primary');

    thumbnails.find("a").on("click", function (event) {
      ($("#main-image")).data("selectedThumb", ($(event.currentTarget)).attr("href"));
      ($("#main-image")).data("selectedThumbId", ($(event.currentTarget)).parent().attr("id"));
      thumbnails.find("li").removeClass("selected");
      thumbnails.find('img').removeClass('border-primary');
      $(this).find('img').addClass('border-primary');
      ($(event.currentTarget)).parent("li").addClass("selected");
      return false
    });

    thumbnails.find('li').on('mouseenter', function (event) {
      $(this).find('img').addClass('border-success');
      return ($('#main-image img')).attr({
        src: $(event.currentTarget).find('a').attr('href'),
        alt: $(event.currentTarget).find('img').attr('alt')
      });
    });

    return thumbnails.find('li').on('mouseleave', function (event) {
      $(this).find('img').removeClass('border-success');
      return $('#main-image img').attr({
        src: $('#main-image').data('selectedThumb'),
        alt: $('#main-image').data('selectedThumbAlt')
      });
    });
  }

  Spree.showVariantImages = function (variantId) {
    ($('li.vtmb')).hide();
    ($('li.tmb-' + variantId)).show();
    var currentThumb = $('#' + ($('#main-image')).data('selectedThumbId'));

    if (!currentThumb.hasClass('vtmb + variantId')) {
      var thumb = $(($('#product-images ul.thumbnails li:visible.vtmb')).eq(0));

      if (!(thumb.length > 0)) {
        thumb = $(($('#product-images ul.thumbnails li:visible')).eq(0));
      }

      var newImg = thumb.find('a').attr('href');

      var newAlt = thumb.find('img').attr('alt');
      ($('#product-images ul.thumbnails li')).removeClass('selected');
      thumb.addClass('selected');
      ($('#main-image img')).attr({ 'src': newImg, 'alt': newAlt });
      ($('#main-image')).data({ 'selectedThumb': newImg, 'selectedThumbAlt': newAlt });
      return ($('#main-image')).data('selectedThumbId', thumb.attr('id'));
    }
  }

  Spree.updateVariantPrice = function (variant) {
    var variantPrice = variant.data('price');

    if (variantPrice) {
      return ($('.price.selling')).text(variantPrice);
    }
  }

  Spree.disableCartForm = function (variant) {
    var inStock = variant.data('in-stock');
    return $('#travel-add-to-cart-button').attr('disabled', !inStock);
  }

  var radios = $("#product-variants input[type='radio']");

  if (radios.length > 0) {
    var selectedRadio = $("#product-variants input[type='radio'][checked='checked']");
    Spree.showVariantImages(selectedRadio.attr('value'));
    Spree.updateVariantPrice(selectedRadio);
    Spree.disableCartForm(selectedRadio);

    radios.click(function (event) {
      $("#product-variants").find('li.active').removeClass("active");
      $(this).closest("li").addClass("active");
      Spree.showVariantImages(this.value);
      Spree.updateVariantPrice($(this));
      return Spree.disableCartForm($(this));
    })
  }

  return Spree.addImageHandlers();
})

Spree.ready(function () {
  var addToCartFormCollection = document.querySelectorAll("[id^='travel-add-to-cart-form']");
  var addToCartButtonCollection = document.querySelectorAll(("[id^='travel-add-to-cart-button']"));

  for (let i = 0; i < addToCartFormCollection.length; i++) {
        var addToCartForm = addToCartFormCollection[i]
        var addToCartButton = addToCartButtonCollection[i]

        if (addToCartForm) {
            // enable add to cart button
            if (addToCartButton) {
                addToCartButton.removeAttribute('disabled')
            }

            addToCartForm.addEventListener('submit', function (event) {
                event.preventDefault()
                var form = event.target
                // prevent multiple clicks
                if (addToCartButton) {
                    addToCartButton.setAttribute('disabled', 'disabled')
                }
                //TODO: This Should be dynamic because if ContextOptionType in the ProductType Change then this code will not work
                var variantId = form.elements.namedItem('variant_id').value;
                var quantity = parseInt(form.elements.namedItem('quantity').value, 10);
                var rateId = form.elements.namedItem('rate_id').value;
                var productId = form.elements.namedItem('product_id').value;
                var productType = form.elements.namedItem('product_type').value;
                var price = form.elements.namedItem('price').value;

                // context params
                var container = document.querySelector(".inside-room-cart-form-"+ variantId + "-" + rateId);
                var context_options =  container.querySelectorAll("input[name^='context[" + productType + "']");
                var context_options_array = Array.from(context_options);

                var context_options_object = {'context': {}};

                context_options_array.forEach(function(e){
                    // remove the `context[` string and the last character `]`
                    context_options_object['context'][e.name.replace('context[', '').slice(0, -1)] = e.value
                });

                // we need to ensure that we have an existing cart we want to add the item to
                // if we have already a cart assigned to this guest / user this won't create
                // another one
                Spree.ensureCart(
                    function () {
                        SpreeAPI.Storefront.travelAddToCart(
                            variantId,
                            quantity,
                            productType,
                            rateId,
                            productId,
                            price,
                            context_options_object,
                            {}, // options hash - you can pass additional parameters here, your backend
                            // needs to be aware of those, see API docs:
                            // https://github.com/spree/spree/blob/master/api/docs/v2/storefront/index.yaml#L42
                            function () {
                                // redirect with `variant_id` is crucial for analytics tracking
                                // provided by `spree_analytics_trackers` extension
                                window.location = Spree.routes.cart + '?variant_id=' + variantId.toString()
                            },
                            function (error) { alert(error) } // failure callback for 422 and 50x errors
                        )
                    }
                )
            })
        }
    }

})
