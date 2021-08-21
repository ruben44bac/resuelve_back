# Resuelve_back

Esta aplicación esta construida con Elixir y Phoenix live_view como framework, además se hizo uso de tailwindcss.
El proyecto publicado se puede encontrar en el siguiente enlace:

[resuelveb](https://resuelveb.gigalixirapp.com/)


## Instalación

Clona el repositorio

```bash
git clone https://github.com/ruben44bac/resuelve_back.git
```

Instala las dependencias por parte de elixir

```bash
cd resuelve_back && mix deps.get
```

Instala las dependencias de node

```bash
cd assets && npm install
```
Finalmente corre la aplicación

```bash
mix phx.server
```

ó si prefieres usa el modo interactivo 

```bash
PORT=4444 iex -S mix phx.server
```


## Uso

La aplicación se encarga de realizar el cálculo del salario total de jugadores, para ingresar basta con entrar a tu localhost y navegar un rato.

```bash
http://localhost:4444/
```

Recuerda que puedes generar la documentación local de la aplicación con

```bash
mix docs
```

Pruebas

```bash
mix test
```

