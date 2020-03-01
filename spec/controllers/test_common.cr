require "../spec_helper"

describe TodoAPI do
  it "returns 200 for GET /healthcheck" do
    get "/healthcheck"

    response.status_code.should eq 200
    response.headers["Access-Control-Allow-Origin"]?.should eq "*"
  end

  # kemal-spec doesn't support options yet, bug raised here:
  # https://github.com/kemalcr/spec-kemal/issues/18
  it "returns CORS headers for OPTIONS /" do
    options "/"

    response.status_code.should eq 200
    response.headers["Access-Control-Allow-Methods"]?.should eq "POST,PUT,PATCH"
    response.headers["Access-Control-Allow-Headers"]?.should eq(
      "Content-Type,If-Modified-Since,Cache-Control"
    )
    response.headers["Access-Control-Max-Age"]?.should eq "86400"
  end

  it "returns 200 for POST /migrate" do
    post "/migrate"

    response.status_code.should eq 200
  end
end
