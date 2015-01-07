source 'https://rubygems.org'

gem 'rails', '4.1.6'

gem 'jquery-rails'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'

gem 'devise'

gem 'kaminari'

gem 'mina'

gem 'prawn'
gem 'prawn-table'

gem 'autoprefixer-rails'
gem 'bootstrap-sass', '~> 3.2.0'
gem 'font-awesome-rails'

gem 'simple_form', '~> 3.1.0.rc1', github: 'plataformatec/simple_form', branch: 'master'

group :production do
  gem 'mysql2'
  gem 'unicorn'
end

group :development, :test do
  gem 'pry-rails'
  gem 'pry-nav'
  gem 'rspec-rails', '~> 3.1.0'
  gem 'rubocop', require: false
  gem 'sqlite3'
  gem 'mailcatcher'
  #gem 'therubyracer'
end

group :test do
  gem 'faker'
  gem 'pdf-inspector', :require => "pdf/inspector"
  gem 'factory_girl', '~> 4.0'
  gem 'shoulda-matchers'
  gem 'simplecov', require: false
end

ruby '2.1.3'
