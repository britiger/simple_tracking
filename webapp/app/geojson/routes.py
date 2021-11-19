from flask import jsonify, render_template, request, abort
from app.geojson import bp
from app import db

from sqlalchemy import text

import json
import time


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


@bp.route('/send_ttn')
def send_ttn():
    
    lat = None
    lon = None
    ident = None
    ts = None
    request_data = {}

    request_json = request.json
    
    # Check TTN V2
    if 'payload_fields' in request_json:
        request_data = request_json['payload_fields']
        request_data['metadata'] = request_json['metadata']
        request_data['counter'] = request_json['counter']
        request_data['frequency'] = request_json['metadata']['frequency']
        request_data['data_rate'] = request_json['metadata']['data_rate']
    # Check TTN V3 Uplink-Msg
    elif 'uplink_message' in request_json:
        ttnv3_uplink = request_json['uplink_message']
        if 'decoded_payload' in ttnv3_uplink:
            request_data = ttnv3_uplink['decoded_payload']
        request_data['metadata']  = ttnv3_uplink['rx_metadata']
        request_data['counter']   = ttnv3_uplink['f_cnt']
        request_data['frequency'] = ttnv3_uplink['settings']['frequency']
        if 'lora' in ttnv3_uplink['settings']['data_rate']:
            request_data['data_rate'] = 'SF'+str(ttnv3_uplink['settings']['data_rate']['lora']['spreading_factor'])+'BW'+str(ttnv3_uplink['settings']['data_rate']['lora']['bandwidth'])
        
        if 'lat' not in request_data and 'latitude' not in request_data:
            if 'locations' in ttnv3_uplink and 'frm-payload' in ttnv3_uplink['locations']:
                request_data['latitude'] = ttnv3_uplink['locations']['frm-payload']['latitude']
                request_data['longitude'] = ttnv3_uplink['locations']['frm-payload']['longitude']
                request_data['altitude'] = ttnv3_uplink['locations']['frm-payload']['altitude']
                request_data['source'] = ttnv3_uplink['locations']['frm-payload']['source']
        
        # pause to prevent to get overwritten by location update posts
        time.sleep(2)
    # Check TTN V3 Location
    elif 'location_solved' in request_json:
        request_data = request_json['location_solved']['location']

    if 'latitude' in request_data:
        lat = request_data['latitude']
    elif 'lat' in request_data:
        lat = request_data['lat']
        
    if 'longitude' in request_data:
        lon = request_data['longitude']
    elif 'lon' in request_data:
        lon = request_data['lon']
    
    if 'dev_id' in request_json:
        # TTN V2
        ident = request_json['dev_id']
    elif 'end_device_ids' in request_json:
        # TTN V3
        ident = request_json['end_device_ids']['device_id']

    if 'metadata' in request_json and 'time' in request_json['metadata']:
        # TTN V2
        ts = request_json['metadata']['time']
    elif 'received_at' in request_json:
        # TTN V3
        ts = request_json['received_at']


    if lat is None or lon is None:
        print('invalid position')
    elif ts is None or ident is None:
        print('No Device data')
        print(str(request.json))
    else:
        sql = text('INSERT INTO simple_tracking.positions (devices_id, data_ts, position, data) VALUES (get_device_id(:ident), (:data_ts)::timestamp, ST_SetSRID(st_point(:lon,:lat), 4326), :data)')
        db.engine.execute(sql, {
            'ident': ident, 
            'data_ts': ts,
            'lat': lat,
            'lon': lon,
            'data': json.dumps(request_data) })

    return jsonify(request_json)


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
