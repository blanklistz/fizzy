Rails.application.configure do
  if vapid = Rails.application.credentials.dig(:vapid)
    config.x.vapid.private_key = vapid[:private_key]
    config.x.vapid.public_key = vapid[:public_key]
  end
end
