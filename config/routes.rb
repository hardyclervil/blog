Rails.application.routes.draw do
  get 'welcome/index'
 
	resources :articles do
  	resources :comments
	end

	get 'lookup' => 'articles#lookup'
 
  root 'welcome#index'
end