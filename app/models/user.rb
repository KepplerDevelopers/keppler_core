require 'elasticsearch/model'
class User < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  before_save :create_permalink, on: :create
  rolify
  validates_presence_of :name, :role_ids, :email

  #has_many :posts, dependent: :destroy relation posts
  
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def rol
    self.roles.first.name
  end

  def self.query(query)
    { query: { multi_match:  { query: query, fields: [:role_name, :name, :email, :permalink] , operator: :and }  }, sort: { id: "desc" }, size: User.count }
  end

  #saber la pagina a la que pertenece
  def page(order = :id)
    ((self.class.order(order => :desc).pluck(order).index(self.send(order))+1).to_f / self.class.default_per_page).ceil
  end

  private

  def create_permalink
    self.permalink = self.name.downcase.parameterize+"-"+SecureRandom.hex(4)
  end

end

#User.import
