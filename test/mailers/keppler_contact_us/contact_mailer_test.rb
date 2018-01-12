require 'test_helper'

module KepplerContactUs
  class ContactMailerTest < ActionMailer::TestCase
    # test "the truth" do
    #   assert true
    # end
    def contact
      @client = KepplerContactUs::Message.new(
        name: 'Anyelo',
        subject: 'Subject',
        email: 'anyelopetit@gmail.com'
        content: 'Contenido',
        read: false
      )
    end
  end
end
