<?php

// error logging all
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

date_default_timezone_set('Europe/Amsterdam');


class BansAPI {
    private $db;

    public function __construct() {
        $db_host = 'localhost';
        $db_name = 'sympactn_db_vacs';
        $db_user = 'sympactn_db_vacs';
        $db_pass = '9pjSqntA';
        $this->db = new PDO("mysql:host=$db_host;dbname=$db_name", $db_user, $db_pass);
    }

    public function add_ban($token, $rbxid) {
        if (!$this->is_token_valid($token)) {
            return array('success' => false, 'message' => 'Invalid token');
        }

        $stmt = $this->db->prepare("INSERT INTO bans (ban_type, banned_at, reason, rbxid) VALUES (:ban_type, :banned_at, :reason, :rbxid)");
        $banned_at = date('Y-m-d H:i:s');
        $ban_type = "A";
        $reason = "Automated Anti-Cheat Ban";

        $stmt->bindParam(':ban_type', $ban_type);
        $stmt->bindParam(':banned_at', $banned_at);
        $stmt->bindParam(':reason', $reason);
        $stmt->bindParam(':rbxid', $rbxid);

        if ($stmt->execute()) {
            return array('success' => true, 'message' => 'Ban added successfully');
        } else {
            return array('success' => false, 'message' => 'Failed to add ban');
        }
    }

    private function is_token_valid($token) {

        if($token == 'esKxpa3kx!49XLz$xNvE') {
            return true;
        } else {
            return false;
        }
   
    }
}

$json_data = file_get_contents('php://input');

$data = json_decode($json_data, true);

if (!isset($data['token']) || !isset($data['ban_type']) || !isset($data['reason']) || !isset($data['rbxid'])) {
    $response = array('success' => false, 'message' => 'Invalid input data');
    echo json_encode($response);
    exit;
}

$token = $data['token'];
$rbxid = $data['rbxid'];

$bans_api = new BansAPI();

$response = $bans_api->add_ban($token, $rbxid);

echo json_encode($response);
?>
