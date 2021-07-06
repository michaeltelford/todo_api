INSERT INTO list (
  user_email, user_name, name, todos, additional_users
)
VALUES (
  'michael.telford@live.com',
  'Michael Telford',
  'Daily',
  '[
    { "name": "Wash Car", "done": false },
    { "name": "Play Records", "done": true },
    { "name": "Watch The Bikes", "done": false },
    { "name": "Write Code", "done": true },
    { "name": "Netflix & Chill", "done": false }
  ]',
  '["todo.checklist@yahoo.com"]'
), (
  'todo.checklist@yahoo.com',
  'Pablito Sanchez',
  'Workout',
  '[
    { "name": "Push Ups", "done": false },
    { "name": "Plank", "done": true },
    { "name": "Pull Ups", "done": false },
    { "name": "Sit Ups", "done": true }
  ]',
  '[]'
), (
  'michael.telford@live.com',
  'Michael Telford',
  'Dev',
  '[
    { "name": "Write Tests", "done": true },
    { "name": "Auth", "done": false },
    { "name": "Models", "done": false },
    { "name": "Controllers", "done": false },
    { "name": "Deploy", "done": false }
  ]',
  '[]'
);
