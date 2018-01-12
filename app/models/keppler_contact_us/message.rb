module KepplerContactUs
  class Message < ActiveRecord::Base
    include ActivityHistory
    validates_presence_of :name, :email

    def self.query(query)
      { query: {
        multi_match:  {
          query: query,
          fields: [:name, :subject, :create_at, :email, :read],
          operator: :and
        }
      }, sort: { id: "desc" }, size: self.count }
    end

    def as_indexed_json(options={})
      {
        id: self.id.to_s,
        name:  self.name,
        subject:  self.subject,
        email:  self.email,
        content:  self.content,
        created_at:  self.created_at.to_s,
      }.as_json
    end

    def self.search_field
      :name_or_subject_or_email_or_content_cont
    end
  end
end
