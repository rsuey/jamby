ruby '2.1.2'
#ruby-gemset=jamby
source 'https://rubygems.org'
source 'https://code.stripe.com'

gem 'rails', '~> 4.1'
gem 'pg', '~> 0.17'
gem 'bcrypt', '~> 3.1'
gem 'permanent_records', '~> 3.1'
gem 'stripe', '~> 1.15'
gem 'aws-sdk', '~> 1.55'

gem 'sidekiq', '~> 3.2'
gem 'pusher', '~> 0.14'

gem "paperclip", "~> 4.2"
gem 'friendly_id', '~> 5.0'
gem 'draper', '~> 1.3'
gem 'gravatar-ultimate', '~> 2.0'

gem 'foundation-rails', '~> 5.3'
gem 'font-awesome-sass', '~> 4.2'
gem 'sass-rails', '~> 4.0'
gem 'uglifier', '>= 1.3'
gem 'coffee-rails', '~> 4.0'
gem 'jquery-rails', '~> 3.1'
gem 'turbolinks', '~> 2.3'
gem 'jbuilder', '~> 2.0'
gem 'rails_autolink', '~> 1.1'
gem 'rehearsal', github: 'joemsak/rehearsal'

gem 'sdoc', '~> 0.4', group: :doc

group :development do
  gem 'spring', '~> 1.1'
end

group :development, :test do
  gem 'dotenv-rails', '~> 0.11'
end

group :test do
  gem 'pusher-fake', '~> 1.2'
  gem 'selenium-webdriver', '~> 2.43'
  gem 'zonebie', '~> 0.5'
  gem 'show_me_the_cookies', '~> 2.5'
  gem 'vcr', '~> 2.9'
  gem 'webmock', '~> 1.18'
  gem 'timecop', '~> 0.7'
  gem 'pry-rails', '~> 0.3'
  gem 'rspec-rails', '~> 3.0'
  gem 'database_cleaner', '~> 1.3'
  gem 'launchy', '~> 2.4'
  gem 'capybara-webkit', '~> 1.2'
  gem 'quiet_assets', '~> 1.0'
  gem 'factory_girl_rails', '~> 4.4'
  gem 'spring-commands-rspec', '~> 1.0'
end

group :production, :staging do
  gem 'rails_12factor', '~> 0.0'
  gem 'unicorn', '~> 4.3'
end
