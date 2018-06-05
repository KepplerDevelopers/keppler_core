echo '##################### Test SCSS ##########################################'
scss-lint app/assets/stylesheets/admin
echo '##################### Test HAML ##########################################'
haml-lint app/views/admin
echo '##################### Test Javascript ####################################'
bundle exec rake jshint
echo '##################### Test Ruby ##########################################'
bundle exec rubocop
echo '##################### RSpec ##############################################'
#bundle exec rspec
echo '##################### Ready ##############################################'
