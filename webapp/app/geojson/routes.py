from flask import jsonify, render_template, request, abort
from app.geojson import bp
from app import db

from sqlalchemy import text

import json


@bp.route('/geojson')
def geojson_points():
    
    sql = text('SELECT *, st_x(position) lon, st_y(position) lat, encode(sha256(d.identifier::bytea), \'hex\') as sha, (extract (EPOCH from (now() - recieved_ts))/60)::int as inactive FROM simple_tracking.positions p LEFT JOIN simple_tracking.devices d on d.id = p.devices_id WHERE latest_position AND position IS NOT NULL;')
    result = db.engine.execute(sql)

    return render_geojson_nodes(result)


@bp.route('/send')
def send():
    request_data = request.args.to_dict()
    ident = request.args.get('id', default=request.remote_addr)
    lat = request.args.get('lat', default=None, type=float)
    lon = request.args.get('lon', default=None, type=float)
    ts = request.args.get('timestamp', default=None, type=int)

    if 'id' in request_data:
        request_data.pop('id')

    if ts is not None and ts > 160346000000:
        ts /= 1000
        request_data['timestamp'] = ts

    if lat is None or lon is None:
        request_data['error'] = 'invalid position'
    else:
        sql = text('INSERT INTO simple_tracking.positions (devices_id, data_ts, position, data) VALUES (get_device_id(:ident), TO_TIMESTAMP(:data_ts), ST_SetSRID(st_point(:lon,:lat), 4326), :data)')
        db.engine.execute(sql, {
            'ident': ident, 
            'data_ts': ts,
            'lat': lat,
            'lon': lon,
            'data': json.dumps(request_data) })

    return jsonify(request_data)


def render_geojson_nodes(result):
    features = []
    for row in result:
        prop = {'id': row['sha'],
                'valid': row['valid_identifier'],
                'inactive': row['inactive'],
                'display_name': row['display_name'],
                'data': row['data']}
        geom = {'type': 'Point', 'coordinates': [row['lon'], row['lat']]}
        entry = {'type': 'Feature', 'properties': prop, 'geometry': geom}
        features.append(entry)

    json_result = {'type': 'FeatureCollection', 'features': features}
    return jsonify(json_result)
