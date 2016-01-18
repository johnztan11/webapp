class TransactionsMailer < ActionMailer::Base
  default from: "Market Vault Downloads <downloads@marketvault.com>"

  def send_to_unsigned_in_user(email, document)
  	mail(to: email, subject: "Download #{document.title}").deliver
  end

end
