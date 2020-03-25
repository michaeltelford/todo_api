CREATE TABLE IF NOT EXISTS list (
  id SERIAL NOT NULL PRIMARY KEY,
  user_id TEXT NOT NULL,
  user_name TEXT NULL,
  name TEXT NOT NULL,
  todos JSON NOT NULL,
  created_on TIMESTAMP NOT NULL DEFAULT CURRENT_DATE,
  updated_on TIMESTAMP NOT NULL DEFAULT CURRENT_DATE
);

INSERT INTO list (user_id, user_name, name, todos) VALUES (
  'michael@yahoo.com', 'Michael', 'Daily',
  '[
    { "name": "Wash Car", "done": false },
    { "name": "Play Records", "done": true },
    { "name": "Watch The Bikes", "done": false },
    { "name": "Write Code", "done": true },
    { "name": "Netflix & Chill", "done": false }
  ]'
), (
  'pablito@yahoo.com', 'Pablito Sanchez', 'Workout',
  '[
    { "name": "Push Ups", "done": false },
    { "name": "Plank", "done": true },
    { "name": "Pull Ups", "done": false }
  ]'
), (
  'michael@yahoo.com', 'Michael', 'Dev',
  '[
    { "name": "Write Tests", "done": true },
    { "name": "Auth", "done": false },
    { "name": "Models", "done": false },
    { "name": "Controllers", "done": false },
    { "name": "Deploy", "done": false }
  ]'
);
