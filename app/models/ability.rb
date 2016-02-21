# Ability Authorizate
class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new # guest user (not logged in)

    if user.has_role? :admin

      # - Seo authorize -
      can :manage, MetaTag
      can :manage, GoogleAdword

      # - GoogleAnalytics authorize -
      if Setting.first.google_analytics_setting.ga_status
        can :manage, GoogleAnalyticsTrack
      end

      # - Setting authorize -
      can :manage, Setting

      # - User authorize -
      can [:delete, :show, :edit, :update,
           :create, :index, :destroy_multiple], User
      can :destroy, User do |u|
        !u.eql?(user)
      end

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
