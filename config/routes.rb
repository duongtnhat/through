Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root 'agent#index'
  get '/:link' => 'agent#link', :constraints => {:link => /.*/}
end
