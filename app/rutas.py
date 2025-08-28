from flask import Blueprint, request, jsonify
from app import db
from app.modelos import Escrito, Comentario, Like, Genero, WatchlistUsuarios, LibrosExternos, ResenasLibros, WatchlistLibros, ModulosAprendizaje, RetosEscritura
from flask_jwt_extended import jwt_required, get_jwt_identity

main_bp = Blueprint('main', __name__)

# --- Rutas para Escritos ---

@main_bp.route('/escritos', methods=['POST'])
@jwt_required()
def crear_escrito():
    data = request.get_json()
    current_user_id = get_jwt_identity()['id']
    
    nuevo_escrito = Escrito(
        titulo=data.get('titulo'),
        contenido=data.get('contenido'),
        sinopsis=data.get('sinopsis'),
        usuario_id=current_user_id,
        genero_id=data.get('genero_id')
    )
    db.session.add(nuevo_escrito)
    db.session.commit()
    
    return jsonify({"msg": "Escrito creado exitosamente", "id": nuevo_escrito.id}), 201

@main_bp.route('/escritos', methods=['GET'])
def obtener_escritos():
    page = request.args.get('page', 1, type=int)
    per_page = request.args.get('per_page', 10, type=int)
    
    escritos = Escrito.query.order_by(Escrito.fecha_publicacion.desc()).paginate(page=page, per_page=per_page, error_out=False)
    
    resultado = [{
        "id": e.id, "titulo": e.titulo, "sinopsis": e.sinopsis, 
        "autor": e.autor.nombre_perfil, "fecha": e.fecha_publicacion
    } for e in escritos.items]
    
    return jsonify({
        "escritos": resultado,
        "total_pages": escritos.pages,
        "current_page": escritos.page
    })

@main_bp.route('/escritos/<int:escrito_id>', methods=['GET'])
def obtener_escrito(escrito_id):
    escrito = Escrito.query.get_or_404(escrito_id)
    return jsonify({
        "id": escrito.id,
        "titulo": escrito.titulo,
        "contenido": escrito.contenido,
        "autor": escrito.autor.nombre_perfil,
        "likes": escrito.likes_count
    })

# --- Rutas para Likes ---

@main_bp.route('/escritos/<int:escrito_id>/like', methods=['POST'])
@jwt_required()
def dar_like(escrito_id):
    current_user_id = get_jwt_identity()['id']
    escrito = Escrito.query.get_or_404(escrito_id)
    
    like_existente = Like.query.filter_by(usuario_id=current_user_id, escrito_id=escrito_id).first()
    if like_existente:
        return jsonify({"msg": "Ya has dado like a este escrito"}), 409
        
    nuevo_like = Like(usuario_id=current_user_id, escrito_id=escrito_id)
    escrito.likes_count += 1
    
    db.session.add(nuevo_like)
    db.session.commit()
    
    return jsonify({"msg": "Like añadido", "total_likes": escrito.likes_count}), 200

# --- Rutas para Comentarios ---

@main_bp.route('/escritos/<int:escrito_id>/comentarios', methods=['POST'])
@jwt_required()
def agregar_comentario(escrito_id):
    data = request.get_json()
    current_user_id = get_jwt_identity()['id']
    
    if not Escrito.query.get(escrito_id):
        return jsonify({"msg": "Escrito no encontrado"}), 404

    nuevo_comentario = Comentario(
        usuario_id=current_user_id,
        escrito_id=escrito_id,
        contenido=data.get('contenido'),
        respuesta_a=data.get('respuesta_a')
    )
    db.session.add(nuevo_comentario)
    db.session.commit()
    
    return jsonify({"msg": "Comentario añadido"}), 201

# --- Rutas para Watchlists ---

@main_bp.route('/watchlist/escritos', methods=['POST'])
@jwt_required()
def agregar_a_watchlist_escrito():
    current_user_id = get_jwt_identity()['id']
    data = request.get_json()
    escrito_id = data.get('escrito_id')

    if not escrito_id or not Escrito.query.get(escrito_id):
        return jsonify({"msg": "Escrito no válido"}), 404

    existente = WatchlistUsuarios.query.filter_by(usuario_id=current_user_id, escrito_id=escrito_id).first()
    if existente:
        return jsonify({"msg": "Este escrito ya está en tu watchlist"}), 409

    nuevo_item = WatchlistUsuarios(usuario_id=current_user_id, escrito_id=escrito_id)
    db.session.add(nuevo_item)
    db.session.commit()
    return jsonify({"msg": "Escrito añadido a tu watchlist"}), 201

# --- Rutas para Reseñas de Libros ---

@main_bp.route('/libros/<int:libro_id>/resena', methods=['POST'])
@jwt_required()
def crear_resena_libro(libro_id):
    current_user_id = get_jwt_identity()['id']
    data = request.get_json()
    puntuacion = data.get('puntuacion')
    reseña_texto = data.get('reseña_texto')

    if not LibrosExternos.query.get(libro_id):
        return jsonify({"msg": "Libro no encontrado"}), 404
    
    if not 1 <= puntuacion <= 5:
        return jsonify({"msg": "La puntuación debe estar entre 1 y 5"}), 400

    nueva_resena = ResenasLibros(
        usuario_id=current_user_id,
        libro_id=libro_id,
        puntuacion=puntuacion,
        reseña_texto=reseña_texto
    )
    db.session.add(nueva_resena)
    db.session.commit()
    return jsonify({"msg": "Reseña añadida exitosamente"}), 201

# --- Rutas para Módulos de Aprendizaje y Retos ---

@main_bp.route('/modulos-aprendizaje', methods=['GET'])
def obtener_modulos():
    modulos = ModulosAprendizaje.query.filter_by(disponible=True).all()
    resultado = [{"id": m.id, "titulo": m.titulo, "descripcion": m.descripcion, "nivel": m.nivel_dificultad, "precio": str(m.precio)} for m in modulos]
    return jsonify(resultado), 200

@main_bp.route('/retos', methods=['GET'])
def obtener_retos():
    retos = RetosEscritura.query.all()
    resultado = [{"id": r.id, "titulo": r.titulo, "descripcion": r.descripcion, "fecha_fin": r.fecha_fin, "premio": r.experiencia_premio} for r in retos]
    return jsonify(resultado), 200