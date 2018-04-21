### KEPPLER ADMIN

KEPPLER ADMIN es una entorno de desarrollo que cuenta con una base de gemas ya integradas, de tal forma que acelerará el desarrollo de aplicaciones de vanguardia bajo la plataforma de Ruby on Rails.


### Características

* Base de datos por defecto MySQL
* Integración para autenticación de usuarios con [Devise](https://github.com/plataformatec/devise)
* Integración para roles de usuarios con [Rolify](https://github.com/RolifyCommunity/rolify)
* Integración para autorizaciones con [CanCanCan](https://github.com/CanCanCommunity/cancancan)
* Inegración para el manejo de de paginación con [Kaminari](https://github.com/amatsuda/kaminari)
* Integración para helpers de formularios con [SimpleForm](https://github.com/RolifyCommunity/rolify)
* Integración para búsquedas full-text con [Ransack](https://github.com/activerecord-hackery/ransack)
* Integración con framework fronte-end para el administrativo con [Materialize](http://materializecss.com/)
* Integración con framework javascript [AngularJs](https://angularjs.org/)
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

### SimpleForm con Materialize

Se ofrece una integración por defecto entre SimpleForm y Materialize, usted tiene la posibilidad de cambiar su funcionalidad en `config/initializers/simple_form_materialize.rb`

Aqui algunos ejemplos para la creacion de inputs:

```ruby
#inputs de tipo text
= f.input :name

#inputs de tipo boolean
= f.input :public, as: :checkbox_material

#inputs de tipo textarea
= f.input :description, input_html: { class: "materialize-textarea" }

#inputs de tipo file
= f.input :image, :as => :file_material, label: false, wrapper_html: { class: "file-field" }

#inputs de tipo select
= f.input :role_ids, collection: Role.all, label: false, include_blank: "Selecione un rol"

#inputs de tipo radio buttons
= f.collection_radio_buttons :option, [['vegan', 'vegan'] ,['vegetarian', 'vegetarian']],:first, :last

#inputs de tipo check_boxes
= f.collection_check_boxes :options, [['vegan', 'vegan'] ,['vegetarian', 'vegetarian']],:first, :last

#inputs de tipo date
= f.input :date, input_html: {class: "datepicker"}
```

**Nota:** *Puede revisar la documentación de [Materialize](http://materializecss.com/) para agregar nuevas integraciones para sus formularios a través de los [Wrappers](https://github.com/plataformatec/simple_form/wiki/Custom-Wrappers) de simpleform.*


### Keppler scaffolds

Keppler ofrece la posibilidad de realizar tareas de scaffolds totalmente configurados para adaptarse de una vez al administrativo. Para crear un nuevo modulo solo tienes que llamar al siguiente comando desde la consola:

`rails g keppler_scaffold [module_name] [attributes] -f`

Luego crea la tabla en base de datos.

`rake db:migrate`
<!-- 
### Plugins (Módulos)

La plataforma permite la adaptación de módulos con facil instalación, algunos de los módulos desarrollados son:

* [Keppler google analytics dashboard](https://github.com/SliceDevelopers/keppler_ga_dashboard) - *ya viene integrado*
* [Keppler blog](https://github.com/SliceDevelopers/keppler_blog)
* [Keppler catalogs](https://github.com/inyxtech/keppler_catalogs)
* [Keppler contact](https://github.com/SliceDevelopers/keppler_contact_us)
 -->