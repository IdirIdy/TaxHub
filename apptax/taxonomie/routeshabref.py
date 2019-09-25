from flask import jsonify, Blueprint, request
from sqlalchemy import distinct, desc, func
from sqlalchemy.orm.exc import NoResultFound


from ..utils.utilssqlalchemy import json_resp, serializeQuery, serializeQueryOneResult
from .models import Habref, CorListHabitat

try:
    from urllib.parse import unquote
except ImportError:
    from urllib import unquote

from . import db

adresses = Blueprint("habref", __name__)


@adresses.route("/search/<field>/<ilike>", methods=["GET"])
@json_resp
def getSearchInField(field, ilike):
    """
    Get the first 20 result of Habref table for a given field with an ilike query
    Use trigram algo to add relevance

    :params field: a Habref column
    :type field: str
    :param ilike: the ilike where expression to filter
    :type ilike:str

    :returns: Array of dict
    """
    habref_columns = Habref.__table__.columns
    if field in habref_columns:
        value = unquote(ilike)
        value = value.replace(" ", "%")
        column = habref_columns[field]
        q = (
            db.session.query(Habref, func.similarity(column, value).label("idx_trgm"))
            .filter(column.ilike("%" + value + "%"))
            .order_by(desc("idx_trgm"))
        )

        data = q.limit(20).all()
        return [d[0].as_dict() for d in data]
    else:
        "No column found in Taxref for {}".format(field), 500


@adresses.route("/habitats/list/<int:id_list>", methods=["GET"])
@json_resp
def get_habref_list(id_list):
    q = (
        db.session.query(Habref)
        .join(CorNomListe, CorListHabitat.cd_hab == CorListHabitat.cd_hab)
        .filter(CorNomListe.id_list == id_list)
    ).all()

    return [d.as_dict() for d in data]


@adresses.route("/habitats/autocomplete/list/<int:id_list>", methods=["GET"])
@json_resp
def get_habref_autocomplete(id_list):
    search_name = request.args.get("search_name")
    q = (
        db.session.query(
            Habref,
            func.similarity(Habref.lb_hab_fr_complet, search_name).label("idx_trgm"),
        )
        .join(CorListHabitat, Habref.cd_hab == CorListHabitat.cd_hab)
        .filter(CorListHabitat.id_list == id_list)
    )
    search_name = search_name.replace(" ", "%")
    q = q.filter(Habref.lb_hab_fr_complet.ilike("%" + search_name + "%")).order_by(
        desc("idx_trgm")
    )

    limit = request.args.get("limit", 20)
    data = q.limit(limit).all()
    return [d[0].as_dict() for d in data]

