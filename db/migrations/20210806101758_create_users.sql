-- +micrate Up
-- SQL in section 'Up' is executed when this migration is applied
CREATE TABLE users(
  id VARCHAR PRIMARY KEY,
  email VARCHAR NOT NULL,
  password VARCHAR NOT NULL,
  first_name VARCHAR NOT NULL,
  last_name VARCHAR NOT NULL
);

-- +micrate Down
-- SQL section 'Down' is executed when this migration is rolled back
DROP TABLE posts;