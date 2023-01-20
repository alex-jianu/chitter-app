TRUNCATE TABLE accounts RESTART IDENTITY;

INSERT INTO accounts (email, name, username, password) VALUES
('ac_one@makersacademy.co.uk', 'Account One', 'acone', 'aconepw'),
('ac_two@makersacademy.co.uk', 'Account two', 'actwo', 'actwopw'),
('ac_three@makersacademy.co.uk', 'Account three', 'acthree', 'acthreepw'),
('ac_four@makersacademy.co.uk', 'Account four', 'acfour', 'acfourpw');
