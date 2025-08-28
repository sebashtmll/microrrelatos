# gestiona la configuración, como la conexión a la base de datos y la 
# clave secreta para la seguridad. 

import os 
from dotenv import load_dotenv

load_dotenv() # Carga las variables de entorno desde un archivo .env

class Config:
    """configuraciones base para la aplicación."""
    SECRET_KEY = os.environ.get ('SECRET_KEY') or '1598753214'
    
    # Configuración de la base de datos (MySQL/MariaDB)
    SQLALCHEMY_DATABASE_URI = os.environ.get('DATABASE_URL') or \
        'mysql+pymysql://root:password@localhost/micro_relatos'
        
    SQLALCHEMY_TRACK_MODIFICATIONS = False
    
    # Configuración para JWT (JSON Web Tokens)
    JWT_SECRET_KEY = os.environ.get('JWT_SECRET_KEY') or 'Sa1598753214'