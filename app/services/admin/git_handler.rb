# frozen_string_literal: true

module Admin
  # Git Handler
  class GitHandler
    def installed?
      branch_name = `git rev-parse --abbrev-ref HEAD`
      branch_name.blank? ? false : true
    rescue StandardError
      false
    end

    def current_branch
      `git rev-parse --abbrev-ref HEAD`
    rescue StandardError
      false
    end

    def changes_count
      changes = `git diff --stat HEAD`
      status_color = changes.blank? ? '#12c752' : '#f98105'
      changes = changes.blank? ? 'No changes' : changes.split("\n").last
      { changes: changes, color: status_color }
    rescue StandardError
      false
    end
  end
end
