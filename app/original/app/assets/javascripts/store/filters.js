/**
 * Created with JetBrains RubyMine.
 * User: peter
 * Date: 17/01/13
 * Time: 0:01
 * To change this template use File | Settings | File Templates.
 * TODO: hacer que en muestren y se escondan und DIVS grandes con toda la informacion adentro
 */

function initOtherRadio(name, value) {


    if (value === 'categories/cars-and-transfers')
    {
        value = 'categories/cars-and-transfers/transfers'
    }

    var radios = document.getElementsByName(name);
    for (i = 0; i < radios.length; i += 1) {
        radio = radios[i];
        radio.onclick = otherRadioHandler;
        // select the first one by default, which hides the appropriate field
        console.log(radio.value)
        if (radio.value === value) {
            radio.click();
        }
    }

    function otherRadioHandler() {

        var destinos = document.getElementById('destinos');
        var adultos = document.getElementById('edad_adultos');
        var ninnos = document.getElementById('edad_ninnos');
        var bebes = document.getElementById('edad_bebes');
        var br_destinos = document.getElementById('br_destinos');
        var br_adultos = document.getElementById('br_adultos');
        var br_ninnos = document.getElementById('br_ninnos');
        var date_program = document.getElementById('date_program');

        var radios_vuelos = document.getElementById('radios_vuelos');
        var origen_vuelos = document.getElementById('origen_vuelos');
        var destinos_vuelos = document.getElementById('destinos_vuelos');
        var partidas = document.getElementById('partidas');
        var regresos = document.getElementById('regresos');
        var adultos_vuelos = document.getElementById('edad_adultos_vuelos');
        var ninnos_vuelos = document.getElementById('edad_ninnos_vuelos');
        var bebes_vuelos = document.getElementById('edad_bebes_vuelos');
        var odv = document.getElementById('odv');

        var entradas = document.getElementById('entradas');
        var salidas = document.getElementById('salidas');
        var destino_alojamiento = document.getElementById('destinos_alojamientos');
        var adultos_alojamientos = document.getElementById('edad_adultos_alojamientos');
        var ninnos_alojamientos = document.getElementById('edad_ninnos_alojamientos');
        var bebes_alojamientos = document.getElementById('edad_bebes_alojamientos');
        var meal_plan_label = document.getElementById('meal_plan_label');
        var meal_plan_select = document.getElementById('meal_plan_accommodation');

        var radios_renta_idas = document.getElementById('radios_renta_idas');
        var autos = document.getElementById('autos');
        var devoluciones = document.getElementById('devoluciones');
        var inicios = document.getElementById('inicios');
        var fines = document.getElementById('fines');
        var transmission_label = document.getElementById('transmission_label');
        var transmission_select = document.getElementById('transmission_rent');

        var origen_traslados = document.getElementById('origen_traslados');
        var destinos_traslados = document.getElementById('destinos_traslados');
        var partidas_traslados = document.getElementById('partidas_traslados');
        var regresos_traslados = document.getElementById('regresos_traslados');
        var odt = document.getElementById('odt');
        var adultos_traslados = document.getElementById('edad_adultos_traslados');
        var ninos_traslados = document.getElementById('edad_ninnos_traslados');
        var bbs_traslados = document.getElementById('edad_bebes_traslados');
        var confort_transfer_label = document.getElementById('transfer-taxi-confort');
        var confort_transfer_select = document.getElementById('confort_transfer');

        if (this.value === 'categories/programs' || this.value === 'categories/tours' )
        {
            //entradas2.className = '';
            destinos.className = '';
            adultos.className = '';
            ninnos.className = '';
            bebes.className = '';
            br_destinos.className = '';
            br_adultos.className = '';
            br_ninnos.className = '';
            date_program.className = '';
        }
        else
        {
            destinos.className = 'hidden';
            adultos.className = 'hidden';
            ninnos.className = 'hidden';
            bebes.className = 'hidden';
            br_destinos.className = 'hidden';
            br_adultos.className = 'hidden';
            br_ninnos.className = 'hidden';
            date_program.className = 'hidden';
        }

        if (this.value === 'categories/flights')
        {
            radios_vuelos.className = '';
            origen_vuelos.className = '';
            destinos_vuelos.className = '';
            partidas.className = '';
            regresos.className = '';
            adultos_vuelos.className = '';
            ninnos_vuelos.className = '';
            bebes_vuelos.className = '';
            odv.className = '';
        }
        else
        {
            radios_vuelos.className = 'hidden';
            origen_vuelos.className = 'hidden';
            destinos_vuelos.className = 'hidden';
            partidas.className = 'hidden';
            regresos.className = 'hidden';
            adultos_vuelos.className = 'hidden';
            ninnos_vuelos.className = 'hidden';
            bebes_vuelos.className = 'hidden';
            odv.className = 'hidden';
        }

        if (this.value === 'categories/accommodation')
        {
            entradas.className = '';
            salidas.className = '';
            destino_alojamiento.className = '';
            adultos_alojamientos.className = '';
            ninnos_alojamientos.className = '';
            bebes_alojamientos.className = '';
            meal_plan_label.className = '';
            meal_plan_select.className = '';
        }
        else
        {
            entradas.className = 'hidden';
            salidas.className = 'hidden';
            destino_alojamiento.className = 'hidden';
            adultos_alojamientos.className = 'hidden';
            ninnos_alojamientos.className = 'hidden';
            bebes_alojamientos.className = 'hidden';
            meal_plan_label.className = 'hidden';
            meal_plan_select.className = 'hidden';
        }

        if(this.value === 'categories/cars-and-transfers/transfers')
        {
            radios_renta_idas.className = '';
            origen_traslados.className = '';
            destinos_traslados.className = '';
            odt.className = '';
            partidas_traslados.className = '';
            regresos_traslados.className = '';
            adultos_traslados.className = '';
            ninos_traslados.className = '';
            bbs_traslados.className = '';
            confort_transfer_label.className = '';
            confort_transfer_select.className = '';
        }
        else
        {
            radios_renta_idas.className = 'hidden';
            origen_traslados.className = 'hidden';
            destinos_traslados.className = 'hidden';
            odt.className = 'hidden';
            partidas_traslados.className = 'hidden';
            regresos_traslados.className = 'hidden';
            adultos_traslados.className = 'hidden';
            ninos_traslados.className = 'hidden';
            bbs_traslados.className = 'hidden';
            confort_transfer_label.className = 'hidden';
            confort_transfer_select.className = 'hidden';
        }

        if (this.value === 'categories/cars-and-transfers/rent-cars')
        {
            autos.className = '';
            devoluciones.className = '';
            inicios.className = '';
            fines.className = '';
            transmission_label.className = '';
            transmission_select.className = '';
        }
        else
        {
            autos.className = 'hidden';
            devoluciones.className = 'hidden';
            inicios.className = 'hidden';
            fines.className = 'hidden';
            transmission_label.className = 'hidden';
            transmission_select.className = 'hidden';
        }

    }

}

function CompareDates(start_date, end_date, days, start)
{
    var sd = document.getElementById(start_date);
    var ed = document.getElementById(end_date);

    var str1 = sd.value
    var str2 = ed.value

    var yr1  = parseInt(str1.substring(0,4),10);
    var mon1 = parseInt(str1.substring(5,7),10);
    var dt1  = parseInt(str1.substring(8,10),10);

    var yr2  = parseInt(str2.substring(0,4),10);
    var mon2 = parseInt(str2.substring(5,7),10);
    var dt2  = parseInt(str2.substring(8,10),10);

    var date1 = new Date(yr1, mon1, dt1);
    var date2 = new Date(yr2, mon2, dt2);

    if(date2 < date1)
    {
        if(start == true)
        {
            date2.setTime(date1.getTime() + (days * 24 * 3600 * 1000));
            ed.value = date2.getFullYear() + "-" + date2.getMonth() + "-" + date2.getDate();
        }
        else
        {
            date1.setTime(date2.getTime() - (days * 24 * 3600 * 1000));
            sd.value = date1.getFullYear() + "-" + date1.getMonth() + "-" + date1.getDate();
        }
    }
}

function clear_search(form_id)
{
    search_form = document.getElementById(form_id);
    for (var i = 0; i < search_form.elements.length; i++)
    {
        if (search_form.elements[i].type == 'checkbox')
        {
            search_form.elements[i].checked = false;
        }
    }
}

function change_search(todo)
{
    var controller = document.getElementById('redirect_controller');
    var radios = document.getElementById('radios');
    var buttons = document.getElementById('form-button');
    var links = document.getElementById('form-link');
    var links_up = document.getElementById('form-link-up');
    var label_search = document.getElementById('label-search');
    var combos = document.getElementById('form-combos');
    var your_search = document.getElementById('your-search');

    if (todo == 'update')
    {
        radios.className = 'hidden';
        buttons.className = '';
        combos.className = '';
        links.className = 'hidden';
        links_up.className = 'hidden';
        label_search.className = 'hidden';
        your_search.className = 'hidden';

        controller.value = 'products';
    }
    else
    {
        radios.className = '';
        buttons.className = '';
        combos.className = '';
        links.className = 'hidden';
        links_up.className = 'hidden';
        label_search.className = 'hidden';
        your_search.className = 'hidden';
    }
}






