CREATE TABLE IF NOT EXISTS list (
  id SERIAL NOT NULL PRIMARY KEY,
  user_id TEXT NOT NULL UNIQUE,
  user_name TEXT NULL,
  todos JSON NOT NULL,
  created_on TIMESTAMP NOT NULL DEFAULT CURRENT_DATE,
  updated_on TIMESTAMP NOT NULL DEFAULT CURRENT_DATE
);

INSERT INTO list (user_id, user_name, todos) VALUES (
  '101', 'Guest',
  '[
    { "name": "Add Some TODOs", "done": false }
  ]'
);
