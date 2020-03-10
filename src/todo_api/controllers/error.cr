error 404 do
  { "error": "Not found" }.to_json
end

error 500 do
  { "error": "An error occurred, try again later" }.to_json
end
