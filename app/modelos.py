# Este archivo debe contener la traducción de tu SQL a modelos de SQLAlchemy.
# Debido a la gran cantidad de tablas, aquí se muestra un ejemplo representativo.
# Se recomienda completar todos los modelos siguiendo este patrón.

from app import db
from datetime import datetime

# --- Modelos de Autenticación y Usuarios ---

class Usuario(db.Model):
    __tablename__ = 'usuarios'
    id = db.Column(db.Integer, primary_key=True)
    identificador = db.Column(db.String(50), unique=True, nullable=False)
    correo = db.Column(db.String(255), unique=True, nullable=False)
    contraseña = db.Column(db.String(255), nullable=False)
    nombre_perfil = db.Column(db.String(100), nullable=False)
    descripcion = db.Column(db.Text)
    experiencia_escritor = db.Column(db.Integer, default=0)
    fecha_registro = db.Column(db.TIMESTAMP, default=datetime.utcnow)
    nivel_escritor = db.Column(db.Integer, default=1)
    
    escritos = db.relationship('Escrito', backref='autor', lazy=True, cascade="all, delete-orphan")
    comentarios = db.relationship('Comentario', backref='autor', lazy=True, cascade="all, delete-orphan")
    likes = db.relationship('Like', backref='autor', lazy=True, cascade="all, delete-orphan")
    clases = db.relationship('ClasesPersonalizadas', backref='estudiante', lazy=True)
    insignias = db.relationship('InsigniasUsuarios', backref='usuario', lazy=True)

# --- Modelos de Contenido (Escritos) ---

class Escrito(db.Model):
    __tablename__ = 'escritos'
    id = db.Column(db.Integer, primary_key=True)
    titulo = db.Column(db.String(200), nullable=False)
    contenido = db.Column(db.Text, nullable=False)
    sinopsis = db.Column(db.Text)
    portada = db.Column(db.String(255))
    usuario_id = db.Column(db.Integer, db.ForeignKey('usuarios.id'), nullable=False)
    genero_id = db.Column(db.Integer, db.ForeignKey('generos.id'))
    fecha_publicacion = db.Column(db.TIMESTAMP, default=datetime.utcnow)
    estado = db.Column(db.String(20), default='publicado')
    likes_count = db.Column(db.Integer, default=0)

    comentarios = db.relationship('Comentario', backref='escrito', lazy=True, cascade="all, delete-orphan")
    likes = db.relationship('Like', backref='escrito', lazy=True, cascade="all, delete-orphan")
    watchlist = db.relationship('WatchlistUsuarios', backref='escrito', lazy=True, cascade="all, delete-orphan")

class Genero(db.Model):
    __tablename__ = 'generos'
    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(50), unique=True, nullable=False)
    descripcion = db.Column(db.Text)
    escritos = db.relationship('Escrito', backref='genero', lazy=True)

class Comentario(db.Model):
    __tablename__ = 'comentarios'
    id = db.Column(db.Integer, primary_key=True)
    usuario_id = db.Column(db.Integer, db.ForeignKey('usuarios.id'), nullable=False)
    escrito_id = db.Column(db.Integer, db.ForeignKey('escritos.id'), nullable=False)
    contenido = db.Column(db.Text, nullable=False)
    fecha_comentario = db.Column(db.TIMESTAMP, default=datetime.utcnow)
    respuesta_a = db.Column(db.Integer, db.ForeignKey('comentarios.id'))
    respuestas = db.relationship('Comentario', backref=db.backref('parent', remote_side=[id]), lazy=True)

class Like(db.Model):
    __tablename__ = 'likes'
    id = db.Column(db.Integer, primary_key=True)
    usuario_id = db.Column(db.Integer, db.ForeignKey('usuarios.id'), nullable=False)
    escrito_id = db.Column(db.Integer, db.ForeignKey('escritos.id'), nullable=False)
    fecha_like = db.Column(db.TIMESTAMP, default=datetime.utcnow)

class WatchlistUsuarios(db.Model):
    __tablename__ = 'watchlist_usuarios'
    id = db.Column(db.Integer, primary_key=True)
    usuario_id = db.Column(db.Integer, db.ForeignKey('usuarios.id'), nullable=False)
    escrito_id = db.Column(db.Integer, db.ForeignKey('escritos.id'), nullable=False)
    fecha_agregado = db.Column(db.TIMESTAMP, default=datetime.utcnow)

# --- Modelos de Libros Externos y Reseñas ---

class LibrosExternos(db.Model):
    __tablename__ = 'libros_externos'
    id = db.Column(db.Integer, primary_key=True)
    google_id = db.Column(db.String(100), unique=True, nullable=False)
    titulo = db.Column(db.String(255), nullable=False)
    autor = db.Column(db.String(255))
    portada_url = db.Column(db.String(255))
    descripcion = db.Column(db.Text)
    fecha_actualizacion = db.Column(db.TIMESTAMP, default=datetime.utcnow, onupdate=datetime.utcnow)

class ResenasLibros(db.Model):
    __tablename__ = 'reseñas_libros'
    id = db.Column(db.Integer, primary_key=True)
    usuario_id = db.Column(db.Integer, db.ForeignKey('usuarios.id'), nullable=False)
    libro_id = db.Column(db.Integer, db.ForeignKey('libros_externos.id'), nullable=False)
    puntuacion = db.Column(db.Integer, nullable=False)
    reseña_texto = db.Column(db.Text)
    fecha_reseña = db.Column(db.TIMESTAMP, default=datetime.utcnow)

class WatchlistLibros(db.Model):
    __tablename__ = 'watchlist_libros'
    id = db.Column(db.Integer, primary_key=True)
    usuario_id = db.Column(db.Integer, db.ForeignKey('usuarios.id'), nullable=False)
    libro_id = db.Column(db.Integer, db.ForeignKey('libros_externos.id'), nullable=False)
    fecha_agregado = db.Column(db.TIMESTAMP, default=datetime.utcnow)

class LibrosPopularesSemanales(db.Model):
    __tablename__ = 'libros_populares_semanales'
    id = db.Column(db.Integer, primary_key=True)
    libro_id = db.Column(db.Integer, db.ForeignKey('libros_externos.id'), nullable=False)
    semana = db.Column(db.Date, nullable=False)
    cantidad_reseñas = db.Column(db.Integer, default=0)
    promedio_puntuacion = db.Column(db.Numeric(3, 2))
    posicion_ranking = db.Column(db.Integer)

# --- Modelos de Aprendizaje y Retos ---

class ModulosAprendizaje(db.Model):
    __tablename__ = 'modulos_aprendizaje'
    id = db.Column(db.Integer, primary_key=True)
    titulo = db.Column(db.String(200), nullable=False)
    descripcion = db.Column(db.Text)
    duracion_horas = db.Column(db.Integer)
    nivel_dificultad = db.Column(db.String(20))
    precio = db.Column(db.Numeric(10, 2))
    disponible = db.Column(db.Boolean, default=True)

class Profesores(db.Model):
    __tablename__ = 'profesores'
    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(100), nullable=False)
    especialidad = db.Column(db.String(100))
    descripcion = db.Column(db.Text)
    tarifa_hora = db.Column(db.Numeric(10, 2))
    disponible = db.Column(db.Boolean, default=True)
    calificacion_promedio = db.Column(db.Numeric(3, 2), default=0.00)

modulos_profesores = db.Table('modulos_profesores',
    db.Column('modulo_id', db.Integer, db.ForeignKey('modulos_aprendizaje.id'), primary_key=True),
    db.Column('profesor_id', db.Integer, db.ForeignKey('profesores.id'), primary_key=True)
)

class ClasesPersonalizadas(db.Model):
    __tablename__ = 'clases_personalizadas'
    id = db.Column(db.Integer, primary_key=True)
    usuario_id = db.Column(db.Integer, db.ForeignKey('usuarios.id'), nullable=False)
    profesor_id = db.Column(db.Integer, db.ForeignKey('profesores.id'))
    modulo_id = db.Column(db.Integer, db.ForeignKey('modulos_aprendizaje.id'))
    fecha_clase = db.Column(db.TIMESTAMP, default=datetime.utcnow)
    duracion_minutos = db.Column(db.Integer, nullable=False)
    estado = db.Column(db.String(20), default='pendiente')
    precio_pagado = db.Column(db.Numeric(10, 2))
    pago_profesor = db.Column(db.Numeric(10, 2))
    fecha_pago = db.Column(db.TIMESTAMP)

class Insignias(db.Model):
    __tablename__ = 'insignias'
    id = db.Column(db.Integer, primary_key=True)
    nombre = db.Column(db.String(100), nullable=False)
    descripcion = db.Column(db.Text)
    imagen_url = db.Column(db.String(255))
    tipo = db.Column(db.String(50))

class InsigniasUsuarios(db.Model):
    __tablename__ = 'insignias_usuarios'
    usuario_id = db.Column(db.Integer, db.ForeignKey('usuarios.id'), primary_key=True)
    insignia_id = db.Column(db.Integer, db.ForeignKey('insignias.id'), primary_key=True)
    fecha_obtencion = db.Column(db.TIMESTAMP, default=datetime.utcnow)
    modulo_id = db.Column(db.Integer, db.ForeignKey('modulos_aprendizaje.id'))

class RetosEscritura(db.Model):
    __tablename__ = 'retos_escritura'
    id = db.Column(db.Integer, primary_key=True)
    titulo = db.Column(db.String(200), nullable=False)
    descripcion = db.Column(db.Text)
    fecha_inicio = db.Column(db.TIMESTAMP, default=datetime.utcnow)
    fecha_fin = db.Column(db.TIMESTAMP, nullable=False)
    nivel_dificultad = db.Column(db.String(20))
    experiencia_premio = db.Column(db.Integer, default=0)

class RetosCompletados(db.Model):
    __tablename__ = 'retos_completados'
    usuario_id = db.Column(db.Integer, db.ForeignKey('usuarios.id'), primary_key=True)
    reto_id = db.Column(db.Integer, db.ForeignKey('retos_escritura.id'), primary_key=True)
    fecha_completado = db.Column(db.TIMESTAMP, default=datetime.utcnow)
    experiencia_obtenida = db.Column(db.Integer, nullable=False)
        
