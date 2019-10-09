from flask import jsonify, Blueprint, request
from sqlalchemy import desc, func
from sqlalchemy.orm.exc import NoResultFound


from ..utils.utilssqlalchemy import json_resp, serializeQuery, serializeQueryOneResult
from .models import Habref, CorListHabitat, AutoCompleteHabitat, TypoRef

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
    """
    Get all habref items for autocomplete

    :param id_list: the id of the habref list 
    :type id_list: int

    :query search_name str: the pattern to filter with
    :query cd_typo int: filter by typology
    :query limit int: number of results, default = 20

    :returns: Array<AutoCompleteHabitat>
    """
    params = request.args
    search_name = params.get("search_name")
    q = (
        db.session.query(
            AutoCompleteHabitat,
            func.similarity(AutoCompleteHabitat.search_name, search_name).label(
                "idx_trgm"
            ),
        )
        .join(CorListHabitat, CorListHabitat.cd_hab == AutoCompleteHabitat.cd_hab)
        .filter(CorListHabitat.id_list == id_list)
    )

    search_name = search_name.replace(" ", "%")
    q = q.filter(
        AutoCompleteHabitat.search_name.ilike("%" + search_name + "%")
    ).order_by(desc("idx_trgm"))

    # filter by typology
    if "cd_typo" in params:
        q = q.filter(AutoCompleteHabitat.cd_typo == params.get("cd_typo"))

    limit = request.args.get("limit", 20)
    data = q.limit(limit).all()
    if data:
        return [d[0].as_dict() for d in data]
    else:
        return "No Result", 404


@adresses.route("/typo", methods=["GET"])
@json_resp
def get_typo():
    """
    Get all typology

    :query int id_list: return only the typology of a given id_list
    :returns: Array<TypoRef>
    """
    params = request.args

    q = db.session.query(TypoRef)

    if params.get("id_list"):
        sub_q = (
            db.session.query(Habref.cd_typo)
            .select_from(Habref)
            .join(CorListHabitat, CorListHabitat.cd_hab == Habref.cd_hab)
            .distinct(Habref.cd_typo)
            .filter(CorListHabitat.id_list == params.get("id_list"))
        )
        q = q.filter(TypoRef.cd_typo.in_(sub_q))
    data = q.order_by(TypoRef.lb_nom_typo).all()

    return [d.as_dict() for d in data]

