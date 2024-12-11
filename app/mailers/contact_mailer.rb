class ContactMailer < ApplicationMailer
  def send_mail(name, email, subject, message)
    @name = name
    @email = email
    @subject = subject
    @message = message

    mail(to: Rails.env.production? ? ENV['GMAIL_USERNAME'] : ENV['MAIL_USERNAME'], subject: @subject) do |format|
      format.text { render plain: @message }
      format.html { render html: render_to_string('send_mail') }
    end
  end

  # カスタマー宛の確認メール
  def send_confirmation_to_customer(name, email, subject, message)
    @name = name
    @email = email
    @subject = subject
    @message = message
    mail(to: @email, subject: '【お問い合わせ確認】' + @subject) do |format|
      format.text { render plain: "お名前: #{@name}\nメッセージ: #{@message}" }
      format.html { render html: render_to_string('send_confirmation') }
    end
  end
end

