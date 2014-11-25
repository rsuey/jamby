module LayoutHelper
  def active_if_current(path)
    'active' if request.fullpath == path
  end

  def label_classes(type)
    'label ' + case type
               when 'live'
                 'success'
               when 'upcoming'
                 'warning'
               else
                 type
               end
  end
end
