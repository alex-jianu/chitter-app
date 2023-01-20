DROP TABLE IF EXISTS accounts, peeps, tags, replies;

CREATE TABLE accounts(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    email TEXT,
    name TEXT,
    username TEXT,
    password TEXT
);

CREATE TABLE peeps(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    content TEXT,
    time TIMESTAMP,
    author TEXT
);

CREATE TABLE replies(
    id INT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    author TEXT,
    content TEXT,
    time TIMESTAMP,
    peep_id INT
);