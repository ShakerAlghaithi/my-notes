Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, ENV["CLIENT_ID"], ENV["CLIENT_SECRET"],
    {
     
      :scope => "email calendar profile plus.me",
      :prompt => "select_account",
      :image_aspect_ratio => "square",
      :image_size => 50
    }
end
