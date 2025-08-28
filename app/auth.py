from flask import Blueprint, request, jsonify
from app import db, bcrypt
from app.modelos import Usuario
from flask_jwt_extended import create_access_token, jwt_required, get_jwt_identity

auth_bp = Blueprint('auth', __name__)

@auth_bp.route('/register', methods=['POST'])
def register():
    data = request.get_json()
    identificador = data.get('identificador')
    correo = data.get('correo')
    contraseña = data.get('contraseña')
    nombre_perfil = data.get('nombre_perfil')

    if Usuario.query.filter_by(correo=correo).first() or Usuario.query.filter_by(identificador=identificador).first():
        return jsonify({"msg": "El correo o identificador ya existen"}), 409

    hashed_password = bcrypt.generate_password_hash(contraseña).decode('utf-8')
    nuevo_usuario = Usuario(
        identificador=identificador,
        correo=correo,
        contraseña=hashed_password,
        nombre_perfil=nombre_perfil
    )
    db.session.add(nuevo_usuario)
    db.session.commit()
    
    return jsonify({"msg": "Usuario creado exitosamente"}), 201

@auth_bp.route('/login', methods=['POST'])
def login():
    data = request.get_json()
    correo = data.get('correo')
    contraseña = data.get('contraseña')

    user = Usuario.query.filter_by(correo=correo).first()

    if user and bcrypt.check_password_hash(user.contraseña, contraseña):
        access_token = create_access_token(identity={'id': user.id, 'identificador': user.identificador})
        return jsonify(access_token=access_token)
    
    return jsonify({"msg": "Correo o contraseña incorrectos"}), 401

@auth_bp.route('/profile', methods=['GET'])
@jwt_required()
def get_profile():
    current_user_id = get_jwt_identity()['id']
    user = Usuario.query.get(current_user_id)
    if not user:
        return jsonify({"msg": "Usuario no encontrado"}), 404
        
    return jsonify({
        "identificador": user.identificador,
        "nombre_perfil": user.nombre_perfil,
        "descripcion": user.descripcion,
        "experiencia": user.experiencia_escritor
    })