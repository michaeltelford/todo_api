class TodoAPI
  def draw_list_routes
    # Get the user's todo lists.
    get "/lists" do |context, _|
      authenticated?(context)

      email, _ = get_current_user(context)
      lists = List.all(email).map { |list| list.to_h(summarise_todos: true) }

      send_json(context, {lists: lists})

      context
    rescue HaltException
      context
    end

    # Get the todo list by ID, providing it belongs to the user.
    get "/list/:id" do |context, url_params|
      authenticated?(context)

      list = List.get(url_params["id"])

      halt(context, HTTP::Status::NOT_FOUND) unless list
      has_access?(context, list)

      send_json(context, {list: list.to_h})

      context
    rescue HaltException
      context
    end

    # Create a todo list belonging to the user.
    post "/list" do |context, _|
      authenticated?(context)

      list_name, todos, additional_users = parse_request(context)
      todos ||= JSON.parse("[]")
      email, user_name = get_current_user(context)

      list = List.new(email, user_name, list_name, todos, additional_users)
      list.save rescue halt(context, HTTP::Status::BAD_REQUEST)

      send_status(context, HTTP::Status::CREATED)

      context
    rescue HaltException
      context
    end

    # Update the todo list by ID, providing it belongs to the user.
    put "/list/:id" do |context, url_params|
      authenticated?(context)

      name, todos, additional_users = parse_request(context)
      list = List.get(url_params["id"])

      halt(context, HTTP::Status::NOT_FOUND) unless list
      has_access?(context, list)

      list.name = name
      list.todos = todos if todos
      list.additional_users = additional_users

      list.save rescue halt(context, HTTP::Status::BAD_REQUEST)
      send_status(context, HTTP::Status::OK)

      context
    rescue HaltException
      context
    end

    # Delete the todo list by ID, providing it belongs to the user.
    delete "/list/:id" do |context, url_params|
      authenticated?(context)

      list = List.get(url_params["id"])

      halt(context, HTTP::Status::NOT_FOUND) unless list
      has_access?(context, list)

      list.delete
      send_status(context, HTTP::Status::NO_CONTENT)

      context
    rescue HaltException
      context
    end
  end
end

private def parse_request(context) : Tuple
  json = get_payload(context)
  list = json["list"]

  {
    list["name"].as_s,
    list["todos"]?,
    list["additional_users"],
  }
rescue
  halt(context, HTTP::Status::BAD_REQUEST)
end
