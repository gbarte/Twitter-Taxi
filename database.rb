CREATE TABLE UserInfo (
    user_id INTEGER NOT NULL PRIMARY KEY,
    firstName TEXT,
    lastName TEXT,
    twitterHandle TEXT, 
    emailAddress VARCHAR, 
    password TEXT
);

CREATE TABLE OrderHistory (
    order_id INTGER NOT NULL PRIMARY KEY,
    user_id INTEGER REFERENCES UserInfo(user_id),
    pickUp VARCHAR,
    destination VARCHAR,
    date DATE,
    time TIME,
    tier TEXT,
    fee DECIMAL, 
    driver_id INTEGER REFERENCES DriverInfo(driver_id)
);

CREATE TABLE Tweets (
    tweet_id INTEGER NOT NULL PRIMARY KEY,
    user_id INTEGER REFERENCES UserInfo(user_id),
    tweet VARCHAR NOT NULL,
    date DATE,
    time TIME
);
