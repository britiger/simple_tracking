from flask import render_template as flask_render_template, request, abort
from app.main import bp
from app import db
from os import environ
from app.geojson.routes import send, send_ttn

from sqlalchemy import text


def render_template(template, **kwargs):
    # Do anything for all routes
    return flask_render_template(template, **kwargs)


@bp.route('/', methods=['GET', 'POST'])
@bp.route('/index')
def index():
    if request.args.get('lat', default=None) is not None and request.args.get('lon', default=None) is not None:
        # process send of geojson if lat/lon is given
        return send()
    user_agent = request.headers.get('User-Agent')
    if user_agent.startswith('http-ttn'):
        return send_ttn()

    return render_template('index.html')

@bp.route('/map')
def map():
    return render_template('map.html')

@bp.route('/settings')
def settings():
    return render_template('settings.html')

@bp.route('/imprint')
def imprint():
    return render_template('imprint.html', imprint_addr=environ.get('imprint_addr'), imprint_mail=environ.get('imprint_mail'))
