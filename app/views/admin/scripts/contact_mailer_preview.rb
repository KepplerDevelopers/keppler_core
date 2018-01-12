# Preview all emails at http://localhost:3000/rails/mailers/application_mailer
class ContactPreview < ActionMailer::Preview
  def contact
    @message = KepplerContactUs::Message.new(
      name: 'Anyelo',
      subject: 'Subject',
      content: 'Contenido',
      email: 'anyelopetit@gmail.com',
      read: false
    )
    # ContactMailer.contact(client)
  end
end
