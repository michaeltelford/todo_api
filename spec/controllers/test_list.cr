require "../spec_helper"

describe TodoAPI do
  it "returns a list for GET /list/:valid_user_email" do
    get "/list/101"

    response.status_code.should eq 200
    response.content_type.should eq "application/json"
    # We use start_with because the timestamps change, so ignore them.
    response.body.should start_with "{\"list\":{\"id\":1,\"user_email\":\"101\",\"user_name\":\"Guest\",\"todos\":[{\"name\":\"Wash Car\",\"done\":false},{\"name\":\"Play Records\",\"done\":true},{\"name\":\"Watch The Bikes\",\"done\":false},{\"name\":\"Write Code\",\"done\":true},{\"name\":\"Netflix And Chill\",\"done\":false}]"
  end

  it "returns 400 for GET /list/:invalid_user_email" do
    get "/list/1001"

    response.content_type.should eq "application/json"
    response.status_code.should eq 400
  end

  it "updates a list for PUT /list/:valid_user_email" do
    put(
      "/list/101",
      headers: HTTP::Headers{"Content-Type" => "application/json"},
      body: {
        list: {
          todos: [
            {
              name: "hello",
              done: true,
            },
          ],
        },
      }.to_json
    )

    response.content_type.should eq "application/json"
    response.status_code.should eq 200

    open do |db|
      db.query_one("SELECT * FROM list WHERE user_email = $1", "101") do |rs|
        to_row(rs, :list)
      end
    end.should eq({1, "101", "Guest", [{"name" => "hello", "done" => true}]})
  end

  it "returns 400 for PUT /list/:invalid_user_email" do
    put "/list/1001"

    response.content_type.should eq "application/json"
    response.status_code.should eq 400
  end

  it "returns 400 for PUT /list/:valid_user_email with invalid json" do
    put "/list/101", body: "{}"

    response.content_type.should eq "application/json"
    response.status_code.should eq 400
  end
end
