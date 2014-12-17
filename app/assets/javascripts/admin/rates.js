function execute_filter () {
    console.log("FILTERING!!")
}


$(document).ready(function() {
    $('#filter_button').attr('onclick', 'execute_filter()');
});
