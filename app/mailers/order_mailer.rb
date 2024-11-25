class OrderMailer < ApplicationMailer
  default from: 'noreply@example.com'

  def status_updated(order)
    @order = order
    @customer = order.customer
    mail(
      to: @customer.email,
      subject: '注文確認のお知らせ',
      content_type: 'text/html; charset=UTF-8'
    )
  end
end
