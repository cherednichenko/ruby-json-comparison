Rails.application.routes.draw do
  namespace :v1 do
    post 'diff/:id/left', to: 'diffs#left', as: :left_diff, format: :json
    post 'diff/:id/right', to: 'diffs#right', as: :right_diff, format: :json
    get 'diff/:id', to: 'diffs#show', as: :diff
  end
end
