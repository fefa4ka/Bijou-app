module ApplicationHelper     
  def omniauth_providers
    %w{ odnoklassniki vkontakte facebook twitter yandex facebook }
    %w{ vkontakte facebook twitter yandex google mailru }
  end

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
