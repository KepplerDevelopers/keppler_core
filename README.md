### KEPPLER ADMIN

Keppler Admin es un CMS con un entorno de desarrollo que cuenta con una base de gemas ya integradas, de tal forma que acelerará el desarrollo de aplicaciones de vanguardia bajo la plataforma de Ruby on Rails.


### Características

* Base de datos por defecto PostreSQL
* Integración para autenticación de usuarios con [Devise](https://github.com/plataformatec/devise)
* Integración para roles de usuarios con [Rolify](https://github.com/RolifyCommunity/rolify)
* Integración para autorizaciones con [Pundit](https://github.com/varvet/pundit)
* Inegración para el manejo de de paginación con [Kaminari](https://github.com/amatsuda/kaminari)
* Integración para helpers de formularios con [SimpleForm](https://github.com/RolifyCommunity/rolify)
* Integración para búsquedas full-text con [Ransack](https://github.com/activerecord-hackery/ransack)
* Integración con framework fronte-end para el administrativo con [AdminLTE](https://adminlte.io/)
* Integración con framework javascript [VueJS](https://vuejs.org/)
* Integración sitemap dinamicos con [Sitemap Generator](https://github.com/kjvarga/sitemap_generator)

### Gema de Keppler

#### Instalación

Una de las novedades de Keppler Admin v2.0 es el lanzamiento de una gema que nos
permite el fácil y rápido manejo de las funcionalidades del CMS. Para instalarlo
necesitamos ejecutar el siguiente comando desde la consola:

`gem install keppler`

#### Lista de comandos

Para verificar que está instalada la gema correctamente y ver una lista de los posibles comandos
que podemos utilizar, ejecutamos:

`keppler`

#### Nuevo Proyecto

Para crear un nuevo proyecto en Ruby on Rails con Keppler Admin, podemos ejecutar:

`keppler new NuevoProyecto`

### Otros comandos:

Los siguientes comandos se ejecutarán automáticamente al ejecutar `keppler new`:

#### Creación del archivo secrets.yml

Si detienes el proceso a la mitad o aún no tienes configurado un archivo `secrets.yml` con la configuración de
la base de datos y otros inicializadores, puedes crear la base de datos ejecutando:

`keppler db_conf`

#### Instalación de las dependencias

Antes de poder iniciar con un proyecto nuevo, primero debemos instalar todas las gemas
instanciadas en el `Gemfile`, ubicado en la raíz del proyecto, con el comando:

`keppler dep`

#### Para acceder al proyecto recién creado:

`cd NuevoProyecto`

### Keppler Modules

Keppler ofrece la posibilidad de realizar tareas de scaffolds totalmente
configurados para adaptarse al administrativo dentro de un rocket ya existente.
Para crear un nuevo módulo sólo debes llamar al siguiente comando desde la consola:

`keppler add module RocketName ModuleName attribute:type attribute:type ...`

Por ejemplo, crearemos un módulo de productos con diversos campos y tipos de datos:

`keppler add module KepplerProducts Product title:string description:text quantity:integer price:float arrival_date:date arrival_time:time available:boolean user:references`

Luego debemos migrar la tabla a la base de datos con:

`keppler migrate`

Si luego deseamos borrar, crear, migrar y llenar la base de datos desde cero,
podemos realizarlo ejecutando el comando:

`keppler reset`

Por último, si todo ha sido ejecutado debida y correctamente, podemos iniciar
el proyecto ejecutando en la consola:

`keppler server`

### SimpleForm con Bootstrap

Se ofrece una integración por defecto entre SimpleForm y Bootstrap, usted tiene la posibilidad de cambiar su funcionalidad en `config/initializers/simple_form_bootstrap.rb`

Aqui algunos ejemplos para la creación de inputs:

```ruby
# Inputs de tipo string o textarea
= f.input :name

# Inputs de tipo CKEditor
= f.input :description, as: :ckeditor, input_html: { ckeditor: { toolbar: 'mini'} }

# Inputs de tipo boolean
= f.input :public, as: :keppler_boolean

# Inputs de tipo file
= f.input :image, as: :keppler_file

# Inputs de tipo select
= f.input :role_ids, collection: Role.all, label: false, include_blank: "Seleccione un rol"

# Inputs de tipo radio buttons
= f.collection_radio_buttons :option, [['vegan', 'vegan'] ,['vegetarian', 'vegetarian']], :first, :last

# Inputs de tipo check_boxes
= f.collection_check_boxes :options, [['vegan', 'vegan'] ,['vegetarian', 'vegetarian']], :first, :last

# Inputs de tipo date
= f.input :date, input_html: { class: 'datepicker' }
```

**Nota:** *Puede revisar la documentación de [AdminLTE](https://adminlte.io) para agregar nuevas integraciones para sus formularios a través de los [Wrappers](https://github.com/plataformatec/simple_form/wiki/Custom-Wrappers) de simpleform.*

### Plugins (Módulos)

La plataforma permite la adaptación de módulos con facil instalación, algunos de los módulos desarrollados son:

* [Keppler Google Analytics Dashboard](https://github.com/slicegroup/keppler_ga_dashboard) - *ya viene integrado*
* [Keppler Blog](https://github.com/slicegroup/keppler_blog)
* [Keppler Catalogs](https://github.com/slicegroup/keppler_catalogs)
* [Keppler Contact](https://github.com/slicegroup/keppler_contact_us)
