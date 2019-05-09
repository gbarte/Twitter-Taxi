require 'sqlite3'

db = SQLite3::Database.new('database.db')

db.execute("CREATE TABLE Admins (
   admin_id    INTEGER NOT NULL,
   email_address    VARCHAR,
   password    VARCHAR NOT NULL,
   PRIMARY KEY(admin_id)
);")

db.execute("CREATE TABLE CarTiers (
    tier_id    INTEGER NOT NULL,
    car_tier    TEXT NOT NULL,
    PRIMARY KEY(tier_id)
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

db.execute("CREATE TABLE Statuses (
    status_id INTEGER NOT NULL,
    status TEXT,
    PRIMARY KEY(status_id)
);")

db.execute("CREATE TABLE CurrentOrders (
    user_id    INTEGER NOT NULL,
    pick_up    VARCHAR NOT NULL,
    destination    VARCHAR NOT NULL,
    time TEXT,
    tier_id INTEGER,
    status_id TEXT,
    offer INTEGER DEFAULT 0,
    PRIMARY KEY(user_id),
    FOREIGN KEY(user_id) REFERENCES UserInfo(user_id),
    FOREIGN KEY(tier_id) REFERENCES CarTiers(tier_id),
    FOREIGN KEY(status_id) REFERENCES Statuses(status_id)
);")

db.execute("CREATE TABLE OrderHistory (
  order_id INTGER NOT NULL,
  user_id INTEGER,
  pickUp VARCHAR,
  destination VARCHAR,
  time TEXT,
  tier_id INTEGER,
  offer INTEGER DEFAULT 0,
  PRIMARY KEY(order_id),
  FOREIGN KEY(tier_id) REFERENCES CarTiers(tier_id),
  FOREIGN KEY(user_id) REFERENCES UserInfo(user_id)
);")

db.execute("CREATE TABLE Tweets (
    tweet_id    INTEGER NOT NULL,
    user_id    INTEGER,
    tweet    VARCHAR NOT NULL,
    time    TEXT,
    PRIMARY KEY(tweet_id),
    FOREIGN KEY(user_id) REFERENCES UserInfo(user_id)
);")

db.execute("INSERT INTO CarTiers(tier_id, car_tier) VALUES(?, ?)", [1, 'Standard'])
db.execute("INSERT INTO CarTiers(tier_id, car_tier) VALUES(?, ?)", [2, 'Extra'])
db.execute("INSERT INTO CarTiers(tier_id, car_tier) VALUES(?, ?)", [3, 'Luxury'])

db.execute("INSERT INTO Statuses(status_id, status) VALUES(?, ?)", [1, 'In progress'])
db.execute("INSERT INTO Statuses(status_id, status) VALUES(?, ?)", [2, 'Completed'])
db.execute("INSERT INTO Statuses(status_id, status) VALUES(?, ?)", [3, 'Cancelled'])

db.execute("INSERT INTO Admins(admin_id, email_address, password) VALUES(?, ?, ?)", [1, 'admintest1@gmail.com', 'passwordtest' ])

db.execute('INSERT INTO OrderHistory VALUES (?, ?, ?, ?, ?, ?)', [1, 1, 'Heaven', 'Diamond' , '2019.03.22', 3, 0])
db.execute('INSERT INTO UserInfo VALUES (?, ?, ?, ?, ?, ?)', [1, 'Nobody', 'Nobody', 'Nobody' , '123@sheffield.ac.uk', '111' ])
db.execute('INSERT INTO OrderHistory VALUES (?, ?, ?, ?, ?, ?)', [1001, 1, 'Earth', 'Mars' , '2119.03.22', 3, 0])
db.execute('INSERT INTO Tweets VALUES (?, ?, ?, ?)', [1, 1, 'standard taxi to the diamond please' , '2119.03.22', 0])
