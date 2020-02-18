CREATE TABLE todos (
  id serial NOT NULL PRIMARY KEY,
  user_id text NOT NULL UNIQUE,
  user_name text NULL,
  todos json NOT NULL,
  created_on TIMESTAMP NOT NULL DEFAULT CURRENT_DATE,
  updated_on TIMESTAMP NOT NULL DEFAULT CURRENT_DATE
);

INSERT INTO todos (user_id, user_name, todos) VALUES
  (
    '19384673', 'Michael Telford',
    '[
  { "name": "Wash Dishes", "done": "true" },
  { "name": "Do Laundry", "done": "true" },
  { "name": "Write Code", "done": "false" },
  { "name": "Watch Netflix", "done": "true" },
  { "name": "Wash Car", "done": "false" }
]'
  ),
  (
    '19384665', 'Pablito Sanchez',
    '[
  { "name": "Clean Silverware", "done": "false" },
  { "name": "Fix Clock", "done": "true" },
  { "name": "Learn Rocket Science", "done": "false" },
  { "name": "Watch Movie", "done": "true" },
  { "name": "Wash Dog", "done": "true" }
]'
  );
