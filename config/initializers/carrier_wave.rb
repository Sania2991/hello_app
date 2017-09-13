if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_credentials = {
      :provider                  => 'DROPBOX',
      :dropbox_access_key_id     => '65wnoxrfsp69cpv',
      :dropbox_secret_access_key => '0u3qoqaigf8cwia'
    }
    config.fog_directory         =  '_eKYh48f5XkAAAAAAAAq48fhBbZaDm8u-U6G7bl79vZLPg7jfeySHPhdDX5Y5nVA'
  end
end