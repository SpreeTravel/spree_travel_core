Deface::Override.new(
    :virtual_path => 'spree/products/show',
    :name => 'replace_product_show_cart_form',
    :replace_contents => "[data-hook='cart_form']",
    :text => "<%case @product.product_type.name%>
              <%when 'hotel'%>
                <%= render partial:'spree/products/hotels/hotel_cart' %>
              <%when 'package'%>
                <%= render partial:'spree/products/packages/package_cart' %>
              <%else%>
              <%end%>",
    :disabled => false
)


