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

date_default_timezone_set('Europe/Amsterdam');
class BansAPI
{
    private $db;

    public function __construct()
    {
        $db_host = 'localhost';
        $db_name = 'vACS';
        $db_user = 'root';
        $db_pass = '';
        $this->db = new PDO("mysql:host=$db_host;dbname=$db_name", $db_user, $db_pass);
    }

    public function add_ban($token, $ban_type, $reason, $rbxid)
    {
        if (!$this->is_token_valid($token))
        {
            return array(
                'success' => false,
                'message' => 'Invalid token'
            );
        }

        $stmt = $this
            ->db
            ->prepare("INSERT INTO bans (ban_type, banned_at, reason, rbxid) VALUES (:ban_type, :banned_at, :reason, :rbxid)");
        $banned_at = date('Y-m-d H:i:s');

        $stmt->bindParam(':ban_type', $ban_type);
        $stmt->bindParam(':banned_at', $banned_at);
        $stmt->bindParam(':reason', $reason);
        $stmt->bindParam(':rbxid', $rbxid);

        if ($stmt->execute())
        {
            return array(
                'success' => true,
                'message' => 'Ban added successfully'
            );
        }
        else
        {
            return array(
                'success' => false,
                'message' => 'Failed to add ban'
            );
        }
    }

    private function is_token_valid($token)
    {

        if ($token == 'SECRET')
        {
            return true;
        }
        else
        {
            return false;
        }

    }
}

$json_data = file_get_contents('php://input');

$data = json_decode($json_data, true);

if (!isset($data['token']) || !isset($data['ban_type']) || !isset($data['reason']) || !isset($data['rbxid']))
{
    $response = array(
        'success' => false,
        'message' => 'Invalid input data'
    );
    echo json_encode($response);
    exit;
}

$token = $data['token'];
$ban_type = $data['ban_type'];
$reason = $data['reason'];
$rbxid = $data['rbxid'];

$bans_api = new BansAPI();

$response = $bans_api->add_ban($token, $ban_type, $reason, $rbxid);

echo json_encode($response);
?>
