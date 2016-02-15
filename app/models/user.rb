require 'elasticsearch/model'
# model user
class User < ActiveRecord::Base
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks
  include PublicActivity::Model
  tracked owner: ->(controller, _) { controller && controller.current_user }
  before_save :create_permalink, on: :create
  rolify
  validates_presence_of :name, :role_ids, :email

  # has_many :posts, dependent: :destroy relation posts

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  after_commit on: [:update] do
    __elasticsearch__.index_document
  end

  def rol
    roles.first.name
  end

  def self.searching(query)
    if query
      search(self.query(query)).records.order(id: :desc)
    else
      order(id: :desc)
    end
  end

  def self.query(query)
    { query: { multi_match: {
      query: query, fields: [:rol, :name, :email, :id], operator: :and }
    }, sort: { id: 'desc' }, size: count }
  end

  # Get the page number that the object belongs to
  def page(order = :id)
    ((self.class.order(order => :desc)
      .pluck(order).index(send(order)) + 1)
        .to_f / self.class.default_per_page).ceil
  end

  # Build index elasticsearch
  def as_indexed_json(_options = {})
    {
      id: id.to_s,
      email: email,
      name: name,
      rol: rol
    }.as_json
  end

  private

  def create_permalink
    self.permalink = name.downcase.parameterize + '-' + SecureRandom.hex(4)
  end
end
