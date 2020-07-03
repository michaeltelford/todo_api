CREATE TABLE IF NOT EXISTS list (
  id SERIAL NOT NULL PRIMARY KEY,
  user_email TEXT NOT NULL,
  user_name TEXT NULL,
  name TEXT NOT NULL,
  todos JSON NOT NULL,
  created_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_on TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);

INSERT INTO list (user_email, user_name, name, todos) VALUES (
  'michael.telford@live.com', 'Michael Telford', 'Daily',
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
    { "name": "Pull Ups", "done": false },
    { "name": "Sit Ups", "done": true }
  ]'
), (
  'michael.telford@live.com', 'Michael Telford', 'Dev',
  '[
    { "name": "Write Tests", "done": true },
    { "name": "Auth", "done": false },
    { "name": "Models", "done": false },
    { "name": "Controllers", "done": false },
    { "name": "Deploy", "done": false }
  ]'
);
