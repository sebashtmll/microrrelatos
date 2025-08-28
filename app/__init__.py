from flask import Flask
from flask_sqlalchemy import SQLAlchemy
from flask_migrate import Migrate
from flask_bcrypt import Bcrypt
from flask_jwt_extended import JWTManager
from config import Config

# Iniciando extensiones
db = SQLAlchemy()
migrate = Migrate()
bcrypt = Bcrypt()
jwt = JWTManager()

def create_app(config_class=Config):
    # Crea y configura la instancia de la aplicación Flask.
    app = Flask(__name__)
    app.config.from_object(config_class)
    
    # Vincular extensiones a la aplicación
    db.init_app(app)
    migrate.init_app(app, db)
    bcrypt.init_app(app)
    jwt.init_app(app)
    
    # Importar y registrar blueprints 
    from app.auth import auth_bp
    app.register_blueprint(auth_bp, url_prefix='/api/auth')
    
    from app.rutas import main_bp
    app.register_blueprint(main_bp, url_prefix='/api')
    
    # Importar modelos para que Alembic los detecte
    from app import modelos

    return app