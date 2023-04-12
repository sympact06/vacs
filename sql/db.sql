CREATE TABLE bans (
    id INT NOT NULL AUTO_INCREMENT,
    ban_type CHAR(1) NOT NULL,
    banned_at DATETIME NOT NULL,
    reason VARCHAR(255) NOT NULL,
    PRIMARY KEY (id)
);

CREATE TABLE users (
    id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    discord_id INT NOT NULL,
    server_id INT NOT NULL,
    renewal_date DATE NOT NULL,
    PRIMARY KEY (id)
);