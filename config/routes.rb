Rails.application.routes.draw do
  resources :uploads
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

get '/uploads/zeig/:name',to:'uploads#zeig' , as:'zeig'
 
post '/uploads/chang/:name',to:'uploads#chang' , as:'chang' 
get '/uploads/delete/:name',to:'uploads#delete' , as:'delete'

get '/uploads/editfile/:name',to:'uploads#editfile' , as:'editfile'


match '/uploads',      to: 'uploads#create',           via: 'post' ,as: 'create'
 

resolve('uploads') { [:uploads] }
end
