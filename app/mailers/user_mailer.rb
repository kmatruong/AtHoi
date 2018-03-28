class UserMailer < ApplicationMailer
  def account_activation user
    @user = user
    mail to: user.email, subject: t("subj")
  end

  def password_reset
    @greeting = t "hi"

    mail to: t("mail_reset")
  end
end
