### KEPPLER ADMIN

KEPPLER ADMIN es una entorno de desarrollo que cuenta con una base de gemas ya integradas, de tal forma que acelerará el desarrollo de aplicaciones de vanguardia bajo la plataforma de Ruby on Rails.


### Características

* Base de datos por defecto MySQL
* Integración para autenticación de usuarios con [Devise](https://github.com/plataformatec/devise)
* Integración para roles de usuarios con [Rolify](https://github.com/RolifyCommunity/rolify)
* Integración para autorizaciones con [Pundit](https://github.com/varvet/pundit)
* Inegración para el manejo de de paginación con [Kaminari](https://github.com/amatsuda/kaminari)
* Integración para helpers de formularios con [SimpleForm](https://github.com/plataformatec/simple_form)
* Integración para búsquedas full-text con [Ransack](https://github.com/activerecord-hackery/ransack)
* Integración con framework fronte-end para el administrativo con [Admin LTE](https://adminlte.io/)
* Integración con framework javascript [VueJS](https://vuejs.org/)
* Integración sitemap dinamicos con [sitemap_generator](https://github.com/kjvarga/sitemap_generator)

### Instalación

```
git clone git@github.com:SliceDevelopers/keppler_admin.git
bundle install
```

Luego debe configurar el archivo `config/secrets.yml` [ver archivo](https://github.com/inyxtech/Keppler-CMS/blob/master/config/secrets.yml.example) de esta manera puede añadir los parámetros de configuración de su base de datos y poder realizar migraciones.

```
rake db:create
rake db:migrate
rake db:seed
```

### Keppler Scaffolds

Keppler ofrece la posibilidad de realizar tareas de scaffolds totalmente configurados para adaptarse de una vez al administrativo. Para crear un nuevo modulo solo tienes que llamar al siguiente comando desde la consola:

`rails g keppler_scaffold [module_name] [attribute:type] [attribute:type] ...`

Por ejemplo:

`rails g keppler_scaffold Example name:string phone:string photo:string age:integer average:float birth:date user:references...`

**Observaciones:**

1. Es importante que si es un campo numérico al cual no se van a aplicar operaciones matemáticas, como por ejemplo
a un DNI, se debe colocar como `string` y no como número entero ni decimal.

2. Para convertir automáticamente un campo a imagen o archivo adjunto, debería llamarse como una de las siguientes opciones:
`logo, brand, photo, avatar, cover, image, picture, banner, attachment, pic, file`

Luego crea la tabla en base de datos.

`rake db:migrate`

### SimpleForm con AdminLTE

Se ofrece una integración por defecto entre SimpleForm y Bootstrap, usted tiene la posibilidad de cambiar su funcionalidad en `config/initializers/simple_form_bootstrap.rb`

Aqui algunos ejemplos para la creacion de inputs:

```ruby
# inputs de tipo text
= f.input :name

# inputs de tipo boolean
= f.input :public, as: :checkbox_material

# inputs de tipo textarea
= f.input :description, input_html: { class: "materialize-textarea" }

# inputs de tipo file
= f.input :image, :as => :file_material, label: false, wrapper_html: { class: "file-field" }

# inputs de tipo select
= f.input :role_ids, collection: Role.all, label: false, include_blank: "Selecione un rol"

# inputs de tipo radio buttons
= f.collection_radio_buttons :option, [['vegan', 'vegan'] ,['vegetarian', 'vegetarian']],:first, :last

# inputs de tipo check_boxes
= f.collection_check_boxes :options, [['vegan', 'vegan'] ,['vegetarian', 'vegetarian']],:first, :last

# inputs de tipo date
= f.input :date, input_html: {class: "datepicker"}
```

**Nota:** *Puede revisar la documentación de [AdminLTE](https://adminlte.io/) para agregar nuevas integraciones para sus formularios a través de los [Wrappers](https://github.com/plataformatec/simple_form/wiki/Custom-Wrappers) de simpleform.*

### Plugins (Módulos)

La plataforma permite la adaptación de módulos con facil instalación, algunos de los módulos desarrollados son:

* [Keppler google analytics dashboard](https://github.com/slicegroup/keppler_ga_dashboard) - *ya viene integrado*
* [Keppler blog](https://github.com/slicegroup/keppler_blog)
* [Keppler catalogs](https://github.com/slicegroup/keppler_catalogs)
* [Keppler contact](https://github.com/slicegroup/keppler_contact_us)
