# frozen_string_literal: true

# Permission
class Permission < ApplicationRecord
  belongs_to :role
end
