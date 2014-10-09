ruby '2.1.2'
#ruby-gemset=jamby
source 'https://rubygems.org'
source 'https://code.stripe.com'

gem 'rails', '~> 4.1.6'
gem 'pg', '~> 0.17.1'
gem 'bcrypt', '~> 3.1.7'
gem 'permanent_records', '~> 3.1.6'
gem 'stripe', '~> 1.15.0'

gem 'pusher', '~> 0.14.1'

gem 'friendly_id', '~> 5.0.4'
gem 'draper', '~> 1.3.1'

gem 'foundation-rails', '~> 5.3.3.0'
gem 'font-awesome-sass', '~> 4.2.0'
gem 'sass-rails', '~> 4.0.3'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.0.0'
gem 'jquery-rails', '~> 3.1.2'
gem 'turbolinks', '~> 2.3.0'
gem 'jbuilder', '~> 2.0'
gem 'rails_autolink', '~> 1.1.6'
gem 'rehearsal', github: 'joemsak/rehearsal'

gem 'sdoc', '~> 0.4.0', group: :doc

group :development do
  gem 'spring', '~> 1.1.3'
end

group :development, :test do
  gem 'dotenv-rails', '~> 0.11.1'
end

group :test do
  gem 'pusher-fake', '~> 1.2.0'
  gem 'selenium-webdriver', '~> 2.43.0'
  gem 'zonebie', '~> 0.5.1'
  gem 'show_me_the_cookies', '~> 2.5.0'
  gem 'vcr', '~> 2.9.3'
  gem 'webmock', '~> 1.18.0'
  gem 'timecop', '~> 0.7.1'
  gem 'pry-rails', '~> 0.3.2'
  gem 'rspec-rails', '~> 3.0.2'
  gem 'database_cleaner', '~> 1.3.0'
  gem 'launchy', '~> 2.4.2'
  gem 'capybara-webkit', '~> 1.2.0'
  gem 'quiet_assets', '~> 1.0.3'
  gem 'factory_girl_rails', '~> 4.4.1'
  gem 'spring-commands-rspec', '~> 1.0.2'
end

group :production, :staging do
  gem 'rails_12factor', '~> 0.0.2'
  gem 'unicorn', '~> 4.3.1'
end
