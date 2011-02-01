mail_config = YAML::load_file(Rails.root.join('config', 'mail.yml'))
DataCatalog::Application.config.action_mailer.default_url_options = {
  :host => mail_config[Rails.env]['host']
}

# Having SSL problems when sending mail? You don't have to disable TLS.
# Instead you can change the OpenSSL verification mode. See:
# http://davidroetzel.wordpress.com/2011/01/14/rails-3-actionmailer-tls-certificate-verification/
# Note: the :openssl_verify_mode option is documented in the Mail gem.
DataCatalog::Application.config.action_mailer.smtp_settings = {
  :openssl_verify_mode => mail_config[Rails.env]['openssl_verify_mode']
}
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
