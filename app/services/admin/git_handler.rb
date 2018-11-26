# frozen_string_literal: true

module Admin
  # Git Handler
  class GitHandler
    def installed?
      @git_branch_name = `git status`
      true
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
      { changes: changes.split("\n").last, color: status_color }
    rescue StandardError
      false
    end
  end
end