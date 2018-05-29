### KEPPLER ADMIN

KEPPLER ADMIN es un CMS con un entorno de desarrollo que cuenta con una base de gemas ya integradas, de tal forma que acelerará el desarrollo de aplicaciones de vanguardia bajo la plataforma de Ruby on Rails.


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

### SimpleForm con Bootstrap

Se ofrece una integración por defecto entre SimpleForm y Bootstrap, usted tiene la posibilidad de cambiar su funcionalidad en `config/initializers/simple_form_bootstrap.rb`

Aqui algunos ejemplos para la creacion de inputs:

```ruby
 # Inputs de tipo string o textarea
= f.input :name

 # Inputs de tipo CKEditor
= f.input :description, as: :ckeditor, input_html: { ckeditor: { toolbar: 'mini'} }

 # Inputs de tipo boolean
= f.input :public, as: :keppler_boolean

 # Inputs de tipo file
= f.input :image, as: :keppler_file, wrapper_html: { class: 'file-field' }

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


### Keppler scaffolds

Keppler ofrece la posibilidad de realizar tareas de scaffolds totalmente configurados para adaptarse de una vez al administrativo. Para crear un nuevo módulo sólo debes llamar al siguiente comando desde la consola:

`rails g keppler_scaffold ModuleName attribute:type`

Por ejemplo:

`rails g keppler_scaffold Product title:string description:text quantity:integer price:float arrival_date:date arrival_time:time available:boolean user:references`

Luego migra la tabla a la base de datos.

`rake db:migrate`
<!--
### Plugins (Módulos)

La plataforma permite la adaptación de módulos con facil instalación, algunos de los módulos desarrollados son:

* [Keppler google analytics dashboard](https://github.com/SliceDevelopers/keppler_ga_dashboard) - *ya viene integrado*
* [Keppler blog](https://github.com/SliceDevelopers/keppler_blog)
* [Keppler catalogs](https://github.com/inyxtech/keppler_catalogs)
* [Keppler contact](https://github.com/SliceDevelopers/keppler_contact_us)
 -->
