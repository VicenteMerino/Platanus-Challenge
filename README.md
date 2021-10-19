# Platanus Challenge

## Descripción

Este es mi solución al desafío para postular al trainee de [Platanus](https://platan.us/recruiting/jobs)

## ¿Cómo ejecutarlo?

Primero es necesario tener [Ruby](https://www.ruby-lang.org/en/) instalado, junto a [Bundler](https://bundler.io/) que se puede instalar ejecutando

```gem install bundler```

Luego, en la raíz del proyecto es necesario instalar las gemas con bundler, ejecutando

```bundler install```

Por último, desde la raíz del proyecto, hay que correr

```ruby src/main.rb```

Con lo cuál se creará el archivo `table.html` en el directorio raíz, el cuál puede ser visto desde un navegador.

## Consideraciones

Para realizar esta tarea, se trató de modularizar usando las clases `ApiHandler` y `Transactions`. No se siguió ningún patrón de diseño en particular pero si se trató que las clases tuvieran alta cohesión y bajo acomplamiento.

Se utilizó la gema `rubocop` como linter desde el proyecto, para hacer el lint de los archivo se puede correr el comando

```rake lint```

Después de cada consulta a la API se agregó un pequeño delay con el fin de que no se excediera el máximo permitido, por lo que puede tomar un poco en terminar de ejecutarse.
