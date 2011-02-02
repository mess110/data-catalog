ConfigFile.load('mail.yml') do |config|
  mailer_config = DataCatalog::Application.config.action_mailer
  mailer_config.default_url_options = { :host => config['host'] }
  smtp_settings = if Rails.env == 'production'
    {
      :address        => config["address"],
      :port           => config["port"],
      :domain         => config["domain"],
      :authentication => :login,
      :user_name      => config["user_name"],
      :password       => config["password"]
    }
  else
    {}
  end
  mailer_config.smtp_settings = smtp_settings.merge({
    :openssl_verify_mode => config['openssl_verify_mode']
  })
end

# Having SSL problems when sending mail? You don't have to disable TLS.
# Instead you can change the OpenSSL verification mode. See:
# http://davidroetzel.wordpress.com/2011/01/14/rails-3-actionmailer-tls-certificate-verification/
# Note: the :openssl_verify_mode option is documented in the Mail gem.
#
# Heads up! If you want the default openssl_verify_mode behavior, you
# need openssl_verify_mode to be nil, so make sure your mail.yml
# openssl_verify_mode line looks like:
#
#     openssl_verify_mode: null
#
# And *not*:
#
#     openssl_verify_mode: nil
#
# Because YAML interprets nil as "nil". You want null, which gets interpreted
# as nil. Here's the code to show it:
#
#     YAML.load("a: nil")  #=> {"a"=>"nil"}
#     YAML.load("a: null") #=> {"a"=>nil}
