

$(function(){
    $(".datepicker").datepicker({
        dateFormat: 'yy-mm-dd'
    })
});

$(function(){
    $(".birthdatepicker").datepicker({
        dateFormat: 'yy-mm-dd',
        changeMonth: true,
        changeYear: true,
        yearRange: "1922:#{Date::today.year()}"
    })
});


