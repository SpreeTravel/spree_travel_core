totals = []

totals << [Prawn::Table::Cell.new( :text => t('subtotal'), :font_style => :bold), number_to_currency(@order.item_total)]

@order.adjustments.each do |charge|
  totals << [Prawn::Table::Cell.new( :text => charge.label + ":", :font_style => :bold), number_to_currency(charge.amount)]
end

totals << [Prawn::Table::Cell.new( :text => t('order_total'), :font_style => :bold), number_to_currency(@order.total)]

bounding_box [0, 0], :width => 530 do
  table totals,
    :position => :right,
    :border_width => 0,
    :vertical_padding   => 2,
    :horizontal_padding => 6,
    :font_size => 9,
    :column_widths => { 0 => 480, 1 => 60 } ,
    :align => { 0 => :right, 1 => :right }

end
