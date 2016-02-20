# User Model
class User < ActiveRecord::Base
  include ElasticSearchable
  include ActivityHistory

  before_save :create_permalink, if: :new_record?
  rolify
  validates_presence_of :name, :role_ids, :email

  # has_many :posts, dependent: :destroy relation posts

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def rol
    roles.first.name
  end

  def self.query(query)
    { query: { multi_match: {
      query: query,
      fields: [:rol, :name, :email, :id],
      operator: :and,
      lenient: true }
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
    as_json(
      only: [:id, :name, :email],
      methods: [:rol]
    )
  end

  private

  def create_permalink
    self.permalink = name.downcase.parameterize + '-' + SecureRandom.hex(4)
  end
end
