### KEPPLER CMS

KEPPLER CMS es una plataforma de aplicaciones de código abierto de vanguardia basado en la plataforma Ruby on Rails.

La plataforma cuenta con una base de gemas ya integradas, de tal forma que acelerará el desarrollo de aplicaciones.

### Características

* Base de datos por defecto MySQL
* Integración para autenticación de usuarios con [Devise](https://github.com/plataformatec/devise)
* Integración para roles de usuarios con [Rolify](https://github.com/RolifyCommunity/rolify)
* Integración para autorizaciones con [CanCanCan](https://github.com/CanCanCommunity/cancancan)
* Inegración para el manejo de de paginación con [Kaminari](https://github.com/amatsuda/kaminari)
* Integración para helpers de formularios con [SimpleForm](https://github.com/RolifyCommunity/rolify)
* Integración para búsquedas full-text con [ElasticSearch](https://github.com/elastic/elasticsearch-rails)
* Integración con framework fronte-end para el administrativo con [Materialize](http://materializecss.com/)
* Integración con framework javascript [AngularJs](https://angularjs.org/)

# Instalación

```
git clone https://github.com/inyxtech/Keppler-CMS.git
bundle install
```

Luego debe configurar el archivo `config/secrets.yml` [ver archivo](https://github.com/inyxtech/Keppler-CMS/blob/master/config/secrets.yml.example) de tal forma que puede añadir los parametros de configuración de su base de datos y poder realizar migraciones.

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

**Nota:** *Puede revisar la docmentación de [Materialize](http://materializecss.com/) para agregar nuevas integraciones para sus formularios a través de los [Wrappers](https://github.com/plataformatec/simple_form/wiki/Custom-Wrappers) de simpleform.*


# Keppler Scaffold

rails g keppler_scaffold <module_name> <attributes>
