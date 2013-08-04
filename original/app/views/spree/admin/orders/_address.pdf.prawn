
# Address Stuff
#TODO Hay que poner esto en la gema de print_invoice y generarla


bill_address = @order.bill_address
pax_contacts = @order.pax_contacts
anonymous = @order.email =~ /@example.net$/

####################Billing#######################
bounding_box [0,600], :width => 250 do
  move_down 2
  data = [[Prawn::Table::Cell.new( :text => I18n.t('contact_information'), :font_style => :bold )]]

  table data,
    :position           => :center,
    :border_width => 0.5,
    :vertical_padding   => 2,
    :horizontal_padding => 6,
    :font_size => 9,
    :border_style => :underline_header,
    :column_widths => { 0 => 250 }

  move_down 2
  horizontal_rule

  bounding_box [0,0], :width => 250 do
    move_down 2
    if anonymous and Spree::Config[:suppress_anonymous_address]
      data2 = [[" "," "]] * 6
    else
      data2 = [["#{bill_address.firstname} #{bill_address.lastname}"], [bill_address.address1]]
      data2 << [bill_address.address2] unless
                bill_address.address2.blank?
      data2 << ["#{@order.bill_address.zipcode} #{@order.bill_address.city}  #{(@order.bill_address.state ? @order.bill_address.state.abbr : "")} "]
      data2 << [bill_address.country.name]
      data2 << [bill_address.phone]
    end

    table data2,
      :position           => :center,
      :border_width => 0.0,
      :vertical_padding   => 0,
      :horizontal_padding => 6,
      :font_size => 9,
      :column_widths => { 0 => 250 }
  end

  move_down 2

  stroke do
    line_width 0.5
    line bounds.top_left, bounds.top_right
    line bounds.top_left, bounds.bottom_left
    line bounds.top_right, bounds.bottom_right
    line bounds.bottom_left, bounds.bottom_right
  end

end


####################Booking#######################
bounding_box [0,525], :width => 250 do
  move_down 2
  data = [[Prawn::Table::Cell.new( :text => I18n.t('booking_information'), :font_style => :bold )]]

  table data,
    :position => :center,
    :border_width => 0.5,
    :vertical_padding   => 2,
    :horizontal_padding => 6,
    :font_size => 9,
    :border_style => :underline_header,
    :column_widths => { 0 => 250 }

  move_down 2
  horizontal_rule

  bounding_box [0,0], :width => 250 do
    move_down 2
    if anonymous and Spree::Config[:suppress_anonymous_address]
      data2 = [[" "," "]] * 6
    else
      data2 = [["Check In: ", @order.check_in]]
      data2 << [["Check Out: ", @order.check_out]]
    end

    table data2,
      :position => :left,
      :border_width => 0.0,
      :vertical_padding   => 0,
      :horizontal_padding => 6,
      :font_size => 9
    #  :column_widths => { 0 => 250 }

  end

  move_down 2

  stroke do
    line_width 0.5
    line bounds.top_left, bounds.top_right
    line bounds.top_left, bounds.bottom_left
    line bounds.top_right, bounds.bottom_right
    line bounds.bottom_left, bounds.bottom_right
  end

end

##################GuestUsers###################################
bounding_box [280,600], :width => 250 do
  move_down 2
  data = [[Prawn::Table::Cell.new( :text =>I18n.t('pax_contacts'), :font_style => :bold )]]

  table data,
    :position           => :center,
    :border_width => 0.5,
    :vertical_padding   => 2,
    :horizontal_padding => 6,
    :font_size => 9,
    :border_style => :underline_header,
    :column_widths => { 0 => 250 }

  move_down 2
  horizontal_rule

  bounding_box [0,0], :width => 270 do
    move_down 2

   pax_contacts.each do |pc|

      if pc.special_capacity == true
        special = 'Has special capacities'
      else
        special = 'No special capacities'
      end

      if anonymous and Spree::Config[:suppress_anonymous_address]
        data3 = [[" "," "]] * 6
      else
        data3 = [["#{pc.first_name}" " #{pc.last_name}"]]
        data3 << [special]
        data3 << [["Sex: ",pc.sex]]
        data3 << [["Age: ",pc.birth ]]

      end

    table data3,
      :position           => :center,
      :border_width => 0.0,
      :vertical_padding   => 0,
      :horizontal_padding => 6,
      :font_size => 9,
      :column_widths => { 0 => 270 }

      move_down 2

     end
  end

  move_down 2

  stroke do
    line_width 0.5
    line bounds.top_left, bounds.top_right
    line bounds.top_left, bounds.bottom_left
    line bounds.top_right, bounds.bottom_right
    line bounds.bottom_left, bounds.bottom_right
  end

end
