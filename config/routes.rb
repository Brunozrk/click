Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'registrations' }

  devise_scope :user do
    get 'success', action: 'success', controller: 'registrations', as: 'success'

    authenticated :user do
      root 'dashboards#index'
    end

    unauthenticated do
      root 'site#index', as: :unauthenticated_root
    end
  end

  get 'reports/export', to: 'reports#export'

  resources :reports
  resources :timetables

  resources :site, only: :index
end
