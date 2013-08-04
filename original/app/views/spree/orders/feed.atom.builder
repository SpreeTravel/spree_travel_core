atom_feed :language => 'es-ES' do |feed|
  feed.title @title
  feed.updated @updated

  @orders.each do |order|
    next if order.updated_at.blank?

    feed.entry(order) do |entry|
      content  = "Orden de Venta (Número #{order.number})<hr>\n"
      order.line_items.each do |item|
        content += item.variant.product.name + "<br>\n"
        content += item.context + "<br>\n"
      end
      content += "Subtotal: #{number_to_currency order.item_total, :precision => 0} <hr>\n"
      order.adjustments.each do |adjustment|
        content += "#{adjustment.label}: #{number_to_currency adjustment.amount, :precision => 0 } <br>"
      end
      content += "<hr>\n"  if order.adjustments.count > 0
      content += "Total: #{number_to_currency order.total, :precision => 0} <hr>\n"
      content += "<a href='http://www.grandslamtravelagency.com/admin/orders/#{order.number}'>Detalles del Pedido</a> | "
      content += "<a href='http://www.grandslamtravelagency.com/admin/orders/#{order.number}/edit'>Editar</a> | "
      if order.state != 'confirmed'
        content += "<a href='http://www.grandslamtravelagency.com/admin/orders/#{order.number}/fire?e=confirm'>Confirmar</a>"
      end

      entry.url "http://www.grandslamtravelagency.com/admin/orders/#{order.number}"
      entry.title "Pedido #{order.number}"
      entry.content content, :type => 'html'

      entry.updated(order.updated_at.strftime("%Y-%m-%dT%H:%M:%SZ"))

      entry.author do |author|
        author.name "GrandSlam Limited"
      end
    end
  end
end