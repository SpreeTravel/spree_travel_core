function loginOverlay(name_on, name_off) {
    var l_off = document.getElementById(name_off);
    l_off.className = 'back_overlay';

    var l_on = document.getElementById(name_on);
    l_on.className = '';
}

function closeOverlay(name) {
    var l = document.getElementById(name);
    l.className = 'back_overlay';
}

function show_destination(name) {
    var l = document.getElementById(name);
    l.style.visible = false;
}