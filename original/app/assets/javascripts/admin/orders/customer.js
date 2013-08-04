/**
 * Created by JetBrains RubyMine.
 * User: raul
 * Date: 9/18/12
 * Time: 10:33 PM
 * To change this template use File | Settings | File Templates.
 */

$(function(){
    $(".birthdatepicker").datepicker({
        dateFormat: 'yy-mm-dd',
        showOn: "both",
        changeMonth: true,
        changeYear: true,
        yearRange: "1922:#{Date::today.year()}",
        buttonImage: "<%= asset_path 'datepicker/cal.gif' %>",
        buttonImageOnly: true
    })
});


