var mymap = L.map('mapid');

L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: 'Map data &copy; <a href="http://openstreetmap.org">OpenStreetMap</a> contributors, <a href="http://creativecommons.org/licenses/by-sa/2.0/">CC-BY-SA</a>',
    maxZoom: 19,
    id: 'OrgMap'
}).addTo(mymap);

mymap.zoomControl.setPosition('bottomleft');
mymap.setView([52.468209, 13.425995], 5);

var fgreenIcon = L.icon.pulse({iconSize:[12,12],color:'green',fillColor:'green',heartbeat: 0.5});
var greenIcon = L.icon.pulse({iconSize:[12,12],color:'green',fillColor:'green',heartbeat: 1});
var yellowIcon = L.icon.pulse({iconSize:[12,12],color:'yellow',fillColor:'yellow',heartbeat: 3});
var redIcon = L.icon.pulse({iconSize:[12,12],color:'red',fillColor:'red',heartbeat: 4});

var geoJSONLayer = L.geoJSON('', { 
    onEachFeature: onEachFeature,
    pointToLayer: function (feature, latlng) {
        iconState = redIcon;
        if (feature.properties.inactive < 5) {
            iconState = fgreenIcon;
        } else if (feature.properties.inactive < 15) {
            iconState = greenIcon;
        } else if (feature.properties.inactive < 60) {
            iconState = yellowIcon;
        }
        return L.marker(latlng, {icon: iconState});
    },
    filter: function(feature) {
        var only_active = Cookies.get('also_inactive') != 'true';
        var valid_only = Cookies.get('valid_only') == 'true';
        if (only_active && feature.properties.inactive > 60) return false;
        if (valid_only && !feature.properties.valid) return false;
        return true;
    }
}).addTo(mymap);

var openMarker = null;
var openId = null;
var updateRunning = false;
currentPositions = [];

function onEachFeature(feature, layer) {
    // generate popupContent
    if (feature.properties && feature.properties.data) {
        var content = "";
        if (feature.properties.display_name) {
            content += "<h3>" + feature.properties.display_name + "</h3>";
        }
        content += "<h5>State: " + feature.properties.inactive + " minutes ago</h5>";
        for (var key in feature.properties.data) {
            content += parseKeyValue(key, feature.properties.data[key]);
        }
        layer.bindPopup(content);
        layer.on('popupopen', function(e) { openId = feature.properties.id; });
        layer.on('popupclose', function(e) { if(!updateRunning) openId = openMarker = null; } );
        if (openId == feature.properties.id) {
            openMarker = layer;
        }
    }
}

function parseKeyValue(key, value) {
    switch (key) {
        case 'lat':
        case 'lon':
        case 'latitude':
        case 'longitude':
            return '';
        case 'timestamp':
            key = '<i class="far fa-clock" title="timestamp"></i>';
            value = (new Date(value*1000)).toLocaleString();
            break;
        case 'batt':
            valueI = parseInt(value)
            color = 'black';
            logo = 'full';
            if (valueI) {
                if (valueI < 15) {
                    color = 'red';
                    logo = 'empty';
                } else if (valueI < 25) {
                    color = 'orange';
                    logo = 'quarter';
                } else if (valueI < 50) {
                    color = 'yellow';
                    logo = 'half';
                } else if (valueI < 75) {
                    color = 'green';
                    logo = 'three-quarters';
                } else {
                    color = 'green';
                }
            }
            key = '<i class="fa fa-battery-' + logo + '" title="battery" style="color: ' + color + '"></i>';
            value = value + ' %';
            break;
        case 'bearing':
        case 'heading':
            key = '<i class="far fa-compass" title="heading"></i>';
            value = parseInt(value) + ' °';
            break;
        case 'altitude':
            key = '<i class="fas fa-chart-area" title="altitude"></i>';
            value = parseInt(value) + ' m';
            break;
        case 'accuracy':
        case 'hdop':
            key = '<i class="fa  fa-bullseye" title="accuracy"></i>';
            value = parseInt(Math.round(value*10.0))/10.0;
            break;
        case 'speed':
            key = '<i class="fas fa-tachometer-alt" title="speed"></i>';
            value = parseInt(value) + ' km/h';
            break;
        case 'sats':
            key = '<i class="fas fa-satellite" title="satellite"></i>';
            break;
        case 'frequency':
            key = '<i class="fas fa-wave-square" title="frequency"></i>';
            value += ' MHz';
            break;
        case 'metadata':
            key = 'gateways';
            if (value.gateways) {
                key = '<i class="fas fa-satellite-dish" title="gateways"></i>';
                value = value.gateways.length;
            } else {
                return '';
            }
            break;
    }

    return key + " : " + value + "<br/>";

}

var refInterval = window.setInterval('update()', 15000); // 15 seconds
var update = function() {
    $.ajax({
        type : 'GET',
        url : '/geojson',
        success : function(data){
            updateRunning = true;
            geoJSONLayer.clearLayers();
            geoJSONLayer.addData(data);
            if (openMarker)
                openMarker.openPopup();
            updateRunning = false;
        },
    });
};
update();
