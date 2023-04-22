/**
 * vACS Project
 * Copyright (C) 2020-2023 Sympact06 & Stuncs69 & TheJordinator
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU Affero General Public License as published
 * by the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU Affero General Public License for more details.
 *
 * You should have received a copy of the GNU Affero General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 *
 * For more information about the vACS Project, visit:
 * https://github.com/sympact06/vacs
 */

                            

CREATE TABLE IF NOT EXISTS bans (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    ban_type ENUM('A','B','C') NOT NULL COMMENT 'Type of ban: A, B, or C (where C is the most aggressive)',
    banned_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    reason VARCHAR(255) NOT NULL COMMENT 'Reason for the ban',
    PRIMARY KEY (id)
) COMMENT 'Table to track banned users and the reason for their ban';

CREATE TABLE IF NOT EXISTS users (
    id INT UNSIGNED NOT NULL AUTO_INCREMENT,
    user_id VARCHAR(200) NOT NULL COMMENT 'ID of the user in the application',
    discord_id VARCHAR(200) NOT NULL COMMENT 'ID of the user in Discord',
    server_id VARCHAR(200) NOT NULL COMMENT 'ID of the server the user is a member of',
    renewal_date DATE NOT NULL COMMENT 'Date when the user\'s subscription is due for renewal',
    PRIMARY KEY (id)
) COMMENT 'Table to store registered users and their details';
