<?php
/*
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
class Database
{
    private $pdo;

    public function __construct($host, $dbname, $user, $pass)
    {
        $dsn = "mysql:host=$host;dbname=$dbname";
        $this->pdo = new PDO($dsn, $user, $pass);
    }

    public function checkServerRenewal($serverId)
    {
        $sql = "SELECT COUNT(*) FROM `users` WHERE `server_id` = :server_id AND `renewal_date` > NOW()";
        $stmt = $this
            ->pdo
            ->prepare($sql);
        $stmt->bindParam(':server_id', $serverId);
        $stmt->execute();
        $count = $stmt->fetchColumn();
        return $count > 0;
    }
}

$db = new Database('localhost', 'vACS', 'root', '');
$serverId = isset($_GET['serverid']) ? $_GET['serverid'] : null;
if ($serverId !== null)
{
    $isRenewed = $db->checkServerRenewal($serverId);
    echo $isRenewed ? "true" : "false";
}
else
{
    echo "Invalid server ID";
}

