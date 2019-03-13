require 'sqlite3'

db = SQLite3::Database.new('database.db')

db.execute("CREATE TABLE Admins (
   admin_id    INTEGER NOT NULL,
   email_address    VARCHAR,
   password    VARCHAR NOT NULL,
   lastest_time_log_in    TIME,
   PRIMARY KEY(admin_id)
);")

db.execute("CREATE TABLE CarTiers (
    tier_id    INTEGER NOT NULL,
    car_tier    TEXT NOT NULL,
    PRIMARY KEY(tier_id)
);")

db.execute("CREATE TABLE CurrentOrders (
    priority    INTEGER NOT NULL,
    user_id    INTEGER NOT NULL,
    pick_up    VARCHAR NOT NULL,
    destination    VARCHAR NOT NULL,
    PRIMARY KEY(user_id),
    FOREIGN KEY(user_id) REFERENCES UserInfo(user_id)
);")

db.execute("CREATE TABLE OrderHistory (
  order_id INTGER NOT NULL,
  user_id INTEGER,
  pickUp VARCHAR,
  destination VARCHAR,
  date DATE,
  time TIME,
  tier_id INTEGER,
  fee DECIMAL,
  PRIMARY KEY(order_id),
  FOREIGN KEY(tier_id) REFEERENCES CarTiers(tier_id),
  FOREIGN KEY(user_id) REFERENCES UserInfo(user_id)
);")

db.execute("CREATE TABLE Tweets (
    tweet_id    INTEGER NOT NULL,
    user_id    INTEGER,
    tweet    VARCHAR NOT NULL,
    date    DATE,
    time    TIME,
    PRIMARY KEY(tweet_id),
    FOREIGN KEY(user_id) REFERENCES UserInfo(user_id)
);")

db.execute("CREATE TABLE UserInfo (
    user_id    INTEGER NOT NULL,
    firstName    TEXT,
    lastName    TEXT,
    twitterHandle    TEXT,
    emailAddress    VARCHAR,
    password    VARCHAR,
    PRIMARY KEY(user_id)
);")