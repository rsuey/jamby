class PageObject
  include ActionView::Helpers
  include Capybara::DSL
  include Rails.application.routes.url_helpers

  def visit
    super(path)
  end

  def fill_in_form(attributes)
    attributes.each do |name, value|
      fill_in name.to_s.humanize, with: value
    end
  end

  def submit_form
    click_button form_button
  end

  def open_in_browser
    save_and_open_page
  end
end
