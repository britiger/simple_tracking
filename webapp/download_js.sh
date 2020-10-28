#!/bin/bash

# Download-Script for depending js libraries

webapp_dir=`dirname $(readlink -f $0)`

js_dir=${webapp_dir}/app/static/js
css_dir=${webapp_dir}/app/static/css
fonts_dir=${webapp_dir}/app/static/webfonts
img_dir=${webapp_dir}/app/static/img

mkdir -p ${js_dir} ${css_dir} ${fonts_dir} ${img_dir} ${css_dir}/images

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

# js-cookie
download_file ${js_dir}/js.cookie.js https://unpkg.com/js-cookie@2.2.1/src/js.cookie.js

# leaflet
download_file ${js_dir}/leaflet.js https://unpkg.com/leaflet@1.7.1/dist/leaflet.js
download_file ${css_dir}/leaflet.css https://unpkg.com/leaflet@1.7.1/dist/leaflet.css
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
download_file ${css_dir}/all-fa5.min.css https://unpkg.com/@fortawesome/fontawesome-free@5.15.1/css/all.min.css
download_file ${fonts_dir}/fa-brands-400.eot https://unpkg.com/@fortawesome/fontawesome-free@5.15.1/webfonts/fa-brands-400.eot
download_file ${fonts_dir}/fa-brands-400.svg https://unpkg.com/@fortawesome/fontawesome-free@5.15.1/webfonts/fa-brands-400.svg
download_file ${fonts_dir}/fa-brands-400.ttf https://unpkg.com/@fortawesome/fontawesome-free@5.15.1/webfonts/fa-brands-400.ttf
download_file ${fonts_dir}/fa-brands-400.woff https://unpkg.com/@fortawesome/fontawesome-free@5.15.1/webfonts/fa-brands-400.woff
download_file ${fonts_dir}/fa-brands-400.woff2 https://unpkg.com/@fortawesome/fontawesome-free@5.15.1/webfonts/fa-brands-400.woff2
download_file ${fonts_dir}/fa-regular-400.eot https://unpkg.com/@fortawesome/fontawesome-free@5.15.1/webfonts/fa-regular-400.eot
download_file ${fonts_dir}/fa-regular-400.svg https://unpkg.com/@fortawesome/fontawesome-free@5.15.1/webfonts/fa-regular-400.svg
download_file ${fonts_dir}/fa-regular-400.ttf https://unpkg.com/@fortawesome/fontawesome-free@5.15.1/webfonts/fa-regular-400.ttf
download_file ${fonts_dir}/fa-regular-400.woff https://unpkg.com/@fortawesome/fontawesome-free@5.15.1/webfonts/fa-regular-400.woff
download_file ${fonts_dir}/fa-regular-400.woff2 https://unpkg.com/@fortawesome/fontawesome-free@5.15.1/webfonts/fa-regular-400.woff2
download_file ${fonts_dir}/fa-solid-900.eot https://unpkg.com/@fortawesome/fontawesome-free@5.15.1/webfonts/fa-solid-900.eot
download_file ${fonts_dir}/fa-solid-900.svg https://unpkg.com/@fortawesome/fontawesome-free@5.15.1/webfonts/fa-solid-900.svg
download_file ${fonts_dir}/fa-solid-900.ttf https://unpkg.com/@fortawesome/fontawesome-free@5.15.1/webfonts/fa-solid-900.ttf
download_file ${fonts_dir}/fa-solid-900.woff https://unpkg.com/@fortawesome/fontawesome-free@5.15.1/webfonts/fa-solid-900.woff
download_file ${fonts_dir}/fa-solid-900.woff2 https://unpkg.com/@fortawesome/fontawesome-free@5.15.1/webfonts/fa-solid-900.woff2