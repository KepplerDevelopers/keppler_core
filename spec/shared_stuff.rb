RSpec.configure do |rspec|
  # This config option will be enabled by default on RSpec 4,
  # but for reasons of backwards compatibility, you have to
  # set it on RSpec 3.
  #
  # It causes the host group and examples to inherit metadata
  # from the shared context.
  rspec.shared_context_metadata_behavior = :apply_to_host_groups
end

RSpec.shared_context "allow user and callbacks", :shared_context => :metadata do
  before (:each) { @user = create(:user) }
  def allow_callbacks
    allow(controller)
        .to receive(:appearance)
        .and_return(nil)
    allow(controller)
        .to receive(:set_admin_locale)
        .and_return(nil)
    allow(controller)
        .to receive(:set_mailer_settings)
        .and_return(nil)  
  end
end

RSpec.configure do |rspec|
  rspec.include_context "allow user and callbacks", :include_shared => true
end