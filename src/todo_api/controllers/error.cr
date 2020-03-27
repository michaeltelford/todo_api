# 404 is for when a resource doesn't exist, a missing route is a 500.
error 404 do |env|
  env.response.content_type = "application/json"
  json = { "error": "Not found" }.to_json
  halt env, status_code: 500, response: json
end

error 500 do |env|
  env.response.content_type = "application/json"
  { "error": "An error occurred, try again later" }.to_json
end
