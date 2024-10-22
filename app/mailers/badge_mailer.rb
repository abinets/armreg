class BadgeMailer < ApplicationMailer
  default from: 'abnios@gmail.com' # Change this to your sender email
  after_action :log_email_status

  def send_badge(participant)
    @participant = participant
    mail(to: @participant.email, subject: 'Your ARM 2024 Badge') do |format|
      format.text { render plain: "Your badge details..." } # Optional
      format.html { render 'send_badge' }
    end
    log_email_status
  end

  private

  def log_email_status
    Rails.logger.info("Email sent to #{@participant.email} at #{Time.current}")
    EmailLog.create(
      participant_id: @participant.id,
      status: 'sent',
      sent_at: Time.current
    )
  end

end
