## MicroBlog App

## Requerimientos

- Python >= 3.9

## Instalación

### Entorno local

Para instalar y ejecutar esto:

```shell
% pip install -r requirements.txt
% flask db upgrade
% exec gunicorn -b :5000 --access-logfile - --error-logfile - microblog:app
```

### Vía docker

- Para hacer el build de la imagen de docker y ejecutarlo localmente:

```shell
% docker build -t microblog:latest .
% docker run -ti --rm -p 5000:5000 microblog:latest
```

- Alternativamente, se puede usar docker compose:

```shell
% docker compose up -d --build --remove-orphans
```

### Testing de la app

Mientras la app se está ejecutando, ir a `http://localhost:5000`

![](../docs/img/login.png)


## Variables de entorno

Las siguientes variables de entorno pueden establecerse o tomarse como predeterminadas para dev o testing o bien para deploys remotos.


| Variable de Entorno       | Obligatoria | Valor Predeterminado             | Notas                                                               |
|---------------------------|-------------|----------------------------------|---------------------------------------------------------------------|
| SECRET_KEY                | No          | `"you-will-never-guess"`         | Usada para la seguridad de la sesión                                |
| SERVER_NAME               | No          | `None`                           | Nombre del servidor Flask                                           |
| DATABASE_URL              | No          | `"sqlite:///<basedir>/app.db"`   | Configuración de base de datos externa. Solo está disponible PostgreSQL |
| LOG_TO_STDOUT             | No          | `None`                           | Habilita el registro en stdout (útil para depuración)              |
| MAIL_SERVER               | No          | `None`                           | Dirección del servidor SMTP                                         |
| MAIL_PORT                 | No          | `25`                             | Puerto del servidor SMTP                                            |
| MAIL_USE_TLS              | No          | `False`                          | Usar TLS para correo electrónico                                    |
| MAIL_USERNAME             | No          | `None`                           | Nombre de usuario SMTP                                              |
| MAIL_PASSWORD             | No          | `None`                           | Contraseña SMTP                                                     |
| MS_TRANSLATOR_KEY         | No          | `None`                           | Clave de API de Microsoft Translator (requerida para traducción en vivo es/en) |
| ELASTICSEARCH_URL         | No          | `None`                           | URL del servidor Elasticsearch. Requerida para indexación de búsqueda |
| REDIS_URL                 | No          | `"redis://"`                     | URL de conexión a Redis. Requerida para Tareas Asíncronas           |
| MAX_POSTS                 | No          | `25`                             | Número de publicaciones por página                                 |

## Descargo de responsabilidad

Parte de la idea de esta aplicación fue tomada del [Curso Flask Mega-Tutorial de Miguel Grinberg](https://blog.miguelgrinberg.com/post/the-flask-mega-tutorial-part-i-hello-world). Todos los créditos para el mismo.
