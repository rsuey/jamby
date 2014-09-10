class SessionsController < ApplicationController
  def new
    load_signin
  end

  private
  def load_signin
    @signin = signin_scope.new
  end

  def signin_scope
    Signup.where(nil)
  end
end
