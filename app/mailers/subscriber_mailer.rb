class SubscriberMailer < Spree::BaseMailer
  def weekly(email, enterprise_products)
    @email = email
    @enterprise_products = enterprise_products
    mail(:to => email,
         :from => from_address,
         :subject => "Latest products in subscribed farmers market")
  end
end
