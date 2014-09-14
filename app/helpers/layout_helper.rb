module LayoutHelper
  def active_if_current(path)
    'active' if request.fullpath == path
  end
end
