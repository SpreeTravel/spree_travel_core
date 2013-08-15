#!/usr/bin/ruby
book = ""
for k in 1..2
	book =""
	if k==1	
		book = Spreadsheet.open "#{Rails.root}/db/load_data/code_ota/OpenTravel_CodeList_2012_8_27.xls" 
	else 
		book = Spreadsheet.open "#{Rails.root}/db/load_data/code_ota/Other_CodeList.xls"
	end
	#book = Spreadsheet.open "#{Rails.root}/db/load_data/code_ota/Other_CodeList.xls"		
	book.worksheets
	sheet = book.worksheet 1
	property_type = ""
	code_value = ""
	for i in 7..30 #sheet.last_row_index  
		if sheet[i,0]
			property_type = sheet[i,0]
			Spree::PropertyType.create!({:name => property_type }, :without_protection => true)			
			puts "property_type: #{property_type}"
			code_value = sheet[i,1]
			puts "code_value: #{code_value}"
		elsif sheet[i,2]
			code_name  = sheet[i,2]	
			property = Spree::Property.create!({:presentation => code_name,
											   :name => "#{code_name}_#{code_value}",												   											 											   
#											   :property_type => property_type
											   },:without_protection => true)    	
			puts "code_name: #{property.presentation}"
			puts "property_type: #{property.name}"
			#puts "code_value: #{property.property_type}"
#			for j in 3..10
#				if sheet[i,j]
#					segment_type = SegmentType.find_or_create_by_name(sheet.row(5)[j])
#					segment_type.segments << segment_type
#					puts "segment_type: #{segment_type.name}"
#				end 
#			end				
		end
	end
end
