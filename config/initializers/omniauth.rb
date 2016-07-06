Rails.application.config.middleware.use OmniAuth::Builder do
  #provider :steam, ENV['13F032EFABFD5AC426B63A115D535D19']
  provider :steam, Rails.application.secrets.STEAM_WEB_API_KEY
end