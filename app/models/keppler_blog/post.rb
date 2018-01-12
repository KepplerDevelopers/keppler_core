module KepplerBlog
  class Post < ActiveRecord::Base
    include ActivityHistory
    include CloneRecord
    # before_save :create_permalink
    mount_uploader :image, ImageUploader
    belongs_to :user
    belongs_to :category
    belongs_to :subcategory
    acts_as_taggable
    acts_as_taggable_on :tags

    validates_presence_of :title, :body, :category_id
    validates_uniqueness_of :title

    # validates_format_of :permalink,
    #   with: /\A[a-z0-9][a-z0-9_\-]*\z/i

    def self.published
      where(public: true).order(created_at: :desc)
    end

    def self.filter_by_autor(autor)
      where(public: true, user: User.find_by_permalink(autor).id).order(created_at: :desc)
    end

    def self.filter_by_category(category)
      where(public: true, category: Category.find_by_permalink(category).id).order(created_at: :desc)
    end

    def self.filter_by_tag(tag)
      where(public: true).tagged_with(tag.gsub("-", " ")).order(created_at: :desc)
    end

    def self.filter_by_subcategory(category, subcategory)
      Category.find_by_permalink(category).subcategories.find_by_permalink(subcategory).posts.order(created_at: :desc)
    end

    def self.query(query)
      { query: { multi_match:  { query: query, fields: [:id, :title, :body, :category, :autor, :subcategory, :public, :comments, :shared, :tags], operator: :and }  }, sort: { id: "desc" }, size: self.count }
    end

    #armar indexado de elasticserch
    def as_indexed_json(options={})
      {
        id: self.id.to_s,
        title: self.title,
        body: ActionView::Base.full_sanitizer.sanitize(self.body, tags: []),
        autor: self.user.name,
        category: self.category.name,
        subcategory: self.subcategory ? self.subcategory.name : "--subcategoria",
        public: self.public ? "si--publicado" : "no--publicado",
        comments: self.comments_open ? "si--comentarios" : "no--comentarios",
        shared: self.shared_enabled ? "si--compartiendo" : "no--compartiendo",
        tags: self.tag_list.to_s
      }.as_json
    end

    def self.search_field
      :title_or_body_or_public_or_comments_open_or_shared_enabled_cont
    end

    private

    def create_permalink
      self.permalink = self.title.downcase.parameterize
    end
  end
  #Post.import
end
