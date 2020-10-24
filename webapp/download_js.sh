#!/bin/bash

# Download-Script for depending js libraries

webapp_dir=`dirname $(readlink -f $0)`

js_dir=${webapp_dir}/app/static/js
css_dir=${webapp_dir}/app/static/css
fonts_dir=${webapp_dir}/app/static/fonts
img_dir=${webapp_dir}/app/static/img

function download_file()
{
    file_name=$1
    url=$2
    if ! [ -f $file_name ]
    then
        wget -O $file_name $url
    fi
}

# bootstrap4
download_file ${css_dir}/bootstrap.min.css https://unpkg.com/bootstrap@4.5.3/dist/css/bootstrap.min.css
download_file ${js_dir}/bootstrap.min.js https://unpkg.com/bootstrap@4.5.3/dist/js/bootstrap.min.js

# jquery
download_file ${js_dir}/jquery.min.js https://unpkg.com/jquery@3.5.1/dist/jquery.min.js

# leaflet
download_file ${js_dir}/leaflet.js https://unpkg.com/leaflet@1.7.1/dist/leaflet.js
download_file ${css_dir}/leaflet.css https://unpkg.com/leaflet@1.7.1/dist/leaflet.css
mkdir -p ${css_dir}/images 
download_file ${css_dir}/images/layers-2x.png https://unpkg.com/leaflet@1.7.1/dist/images/layers-2x.png
download_file ${css_dir}/images/layers.png https://unpkg.com/leaflet@1.7.1/dist/images/layers.png
download_file ${css_dir}/images/marker-icon.png https://unpkg.com/leaflet@1.7.1/dist/images/marker-icon.png
download_file ${css_dir}/images/marker-icon-2x.png https://unpkg.com/leaflet@1.7.1/dist/images/marker-icon-2x.png
download_file ${css_dir}/images/marker-shadow.png https://unpkg.com/leaflet@1.7.1/dist/images/marker-shadow.png
# leaflet-markercluster
download_file ${js_dir}/leaflet.markercluster.js https://unpkg.com/leaflet.markercluster@1.4.1/dist/leaflet.markercluster.js
download_file ${css_dir}/MarkerCluster.css https://unpkg.com/leaflet.markercluster@1.4.1/dist/MarkerCluster.css
download_file ${css_dir}/MarkerCluster.Default.css https://unpkg.com/leaflet.markercluster@1.4.1/dist/MarkerCluster.Default.css
# leaflet-pulse
download_file ${js_dir}/L.Icon.Pulse.js https://unpkg.com/@ansur/leaflet-pulse-icon@0.1.1/src/L.Icon.Pulse.js
download_file ${css_dir}/L.Icon.Pulse.css https://unpkg.com/@ansur/leaflet-pulse-icon@0.1.1/src/L.Icon.Pulse.css
# font awesome 
download_file ${css_dir}/font-awesome.min.css https://unpkg.com/font-awesome@4.7.0/css/font-awesome.min.css
download_file ${fonts_dir}/fontawesome-webfont.eot https://unpkg.com/font-awesome@4.7.0/fonts/fontawesome-webfont.eot
download_file ${fonts_dir}/fontawesome-webfont.ttf https://unpkg.com/font-awesome@4.7.0/fonts/fontawesome-webfont.ttf
download_file ${fonts_dir}/fontawesome-webfont.svg https://unpkg.com/font-awesome@4.7.0/fonts/fontawesome-webfont.svg
download_file ${fonts_dir}/fontawesome-webfont.woff https://unpkg.com/font-awesome@4.7.0/fonts/fontawesome-webfont.woff
download_file ${fonts_dir}/fontawesome-webfont.woff2 https://unpkg.com/font-awesome@4.7.0/fonts/fontawesome-webfont.woff2