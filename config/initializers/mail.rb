mail_config = YAML::load_file(Rails.root.join('config', 'mail.yml'))
DataCatalog::Application.config.action_mailer.default_url_options = {
  :host => mail_config[Rails.env]['host']
}
