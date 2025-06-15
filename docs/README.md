# Diagrama de clases

El siguiente diagrama de clases muestra las principales clases (siendo la principal claramente `User`).
Por una cuestión de simplicidad no se muestran los métodos de clase.

```mermaid
---
title: 84GIIN - Trabajo de Fin de Grado - Diagramas de clases
---
classDiagram

    %% Cardinalidad

    User "1" --> "many" Post
    User "1" --> "many" Notification
    User "1" --> "many" Task
    User "many" --> "many" Message

    %% Definiciones de clases

    class User {
        -int id
        -str username
        -str password_hash
        -str about_me
        -datetime last_seen
        -datetime last_message_read_time
        -str token
        -datetime token_expiration
        -Post posts
        -User following
        -User followers
        -Message messages_sent
        -Message messages_received
        -Notification notifications
        -Task tasks
    }

    class Post {
        -int id
        -str body
        -datetime timestamp
        -int user_id
        -str language
        -User author
    }

    class Message {
        -int id
        -int sender_id
        -int recipient_id
        -str body
        -datetime timestamp
    }

    class Notification {
      -int id
      -str name
      -int user_id
      -float timestamp
      -str payload_json
      -User user
    }

    class Task {
        -str id
        -str name
        -str description
        -int user_id
        -bool complete
        -User user
    }
```

---

# Diagrama Entidad-Relacion (ERD)

El siguiente diagrama muestra el esquema de clases en la base de datos del proyecto de microblog.

Las 6 grandes entidades como se pueden ver son:
- **User:** Un usuario simple.
- **Message:** Un mensaje a ser enviado entre usuarios.
- **Notification:** Una notificación que le aparece a cada usuario.
- **Task:** Una tarea pero no para el usuario si no más bien un background task.
- **Post:** Un posteo, esto es, una entrada en el blog.
- **Follower:** Tabla intermedia para relacion `M:N` entre usuarios como followers (similar al concepto de twitter o instagram).

![](./img/diagrama-erd.png)
