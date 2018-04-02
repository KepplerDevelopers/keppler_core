### Keppler google analytics dashboard v1.0.0

Engine integrado con google analytics que proporiciona un dashboard agradable, presentando algunas metricas sobre las visitas.

## Requerimientos

* keppler-admin >= 1.0

### Instalación

Añadir a su Gemfile

```ruby
gem 'keppler_ga_dashboard', git: 'https://github.com/SliceDevelopers/keppler_ga_dashboard.git', tag: "1.0.0"
gem 'google-api-client'
```

Añadir la siguiente linea a su manifesto stylesheets `application.scss`

```ruby
@import 'dashboard'
```

Añadir la siguiente ruta a su archivo `routes.rb`

```ruby
mount KepplerGaDashboard::Engine, :at => '', as: 'dashboard'
```

### Configuración

El engine necesita que el usuario cree una api para google analitycs, esto lo puedes conseguir desde (https://console.developers.google.com), debes crear un  proyecto, luego crear un cliente y selecionar la opción **cuenta de servicio**, una vez creado hay que generar una calve p12 y guardar el archivo en el directorio `config/gaAuth` de su app.

Luego de haber realizado esto debe agregar los datos de configuración en `secrets.yml` bajo la siguiente configuracion:

```yml
ga_auth:
  :service_account_email_address: "dirección de correo electronico generada por la api"
  :file_key_name: "nombre del archio p12 generado por la api"
  :account_id: "id de la cuenta de google analytics"
```

**Nota:** *Asegurese de darle permisos a la api desde su cuenta de google analitycs*

### Vista

Para copiar las vista a tu proyecto y asi personalizarlas para adaptarlas y agregar nuevos reportes, debe ejecutar

```ruby
rake dashboard:copy_views
```
