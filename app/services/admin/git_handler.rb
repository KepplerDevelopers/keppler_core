# frozen_string_literal: true

module Admin
  # Git Handler
  class GitHandler

    def installed?
      @git_branch_name = `git status`
      return true
    rescue StandardError
      return false
    end

    def current_branch
      `git rev-parse --abbrev-ref HEAD`
    rescue StandardError
      return false
    end

    def changes_count
      status = `git diff --stat HEAD`
      status_color = status.blank? ? '#12c752' : '#f98105'
      { status: status.split("\n").last, color: status_color }
    rescue StandardError
      return false
    end
  end
end