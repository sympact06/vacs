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

    public function remove_ban($token, $rbxid) {
        if (!$this->is_token_valid($token)) {
            return array('success' => false, 'message' => 'Invalid token');
        }

        $stmt = $this->db->prepare("DELETE FROM bans WHERE rbxid = :rbxid");

        $stmt->bindParam(':rbxid', $rbxid);

        if ($stmt->execute()) {
            return array('success' => true, 'message' => 'Ban removed successfully');
        } else {
            return array('success' => false, 'message' => 'Failed to remove ban');
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

if (!isset($data['token']) || !isset($data['rbxid'])) {
    $response = array('success' => false, 'message' => 'Invalid input data');
    echo json_encode($response);
    exit;
}

$token = $data['token'];
$rbxid = $data['rbxid'];

$bans_api = new BansAPI();

$response = $bans_api->remove_ban($token, $rbxid);

echo json_encode($response);
?>
