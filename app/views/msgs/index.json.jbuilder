json.array!(@msgs) do |msg|
  json.extract! msg, :room, :sender, :body
  json.url msg_url(msg, format: :json)
end