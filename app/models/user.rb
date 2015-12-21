require 'elasticsearch/model'
class User < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include PublicActivity::Model
  tracked owner: ->(controller, model) { controller && controller.current_user }
  before_save :create_permalink, on: :create
  rolify
  validates_presence_of :name, :role_ids, :email

  #has_many :posts, dependent: :destroy relation posts
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_commit on: [:update] do
    puts __elasticsearch__.index_document
  end

  def rol
    self.roles.first.name
  end

  def self.searching(query)
    if query
      self.search(self.query query).records.order(id: :desc)
    else
      self.order(id: :desc)
    end
  end

  def self.query(query)
    { query: { multi_match:  { query: query, fields: [:rol, :name, :email, :id] , operator: :and }  }, sort: { id: "desc" }, size: User.count }
  end

  #saber la pagina a la que pertenece
  def page(order = :id)
    ((self.class.order(order => :desc).pluck(order).index(self.send(order))+1).to_f / self.class.default_per_page).ceil
  end

  #armar indexado de elasticserch
  def as_indexed_json(options={})
    {
      id: self.id.to_s,
      email: self.email,
      name: self.name,
      rol: self.rol
    }.as_json
  end

  private

  def create_permalink
    self.permalink = self.name.downcase.parameterize+"-"+SecureRandom.hex(4)
  end

end

#User.import
