# Ability Authorizate
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.has_role? :keppler_admin

      # - Keppler Admin can manage everything -
      can :manage, :all

      # - Keppler Admin cannot clone users, scripts or SEO models -
      cannot :clone, [User, Script, GoogleAdword, MetaTag]

      # - GoogleAnalytics authorize -
      # if Setting.first.google_analytics_setting.ga_status
      #   can :manage, Script
      # end
      if user.present?  # additional permissions for logged in users (they can manage their posts)
        cannot :destroy, User
      end

    elsif user.has_role? :admin

      # - Admin authorize -
      can :manage, User
      cannot :clone, [User, Script, GoogleAdword, MetaTag]
      cannot :destroy, User, user: !user.id

    elsif user.has_role? :client

    end
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
