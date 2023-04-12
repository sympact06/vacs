<?php

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

    public function get_ban_data($token, $rbxid) {
        if (!$this->is_token_valid($token)) {
            return array('success' => false, 'message' => 'Invalid token');
        }

        $stmt = $this->db->prepare("SELECT * FROM bans WHERE rbxid = :rbxid");

        $stmt->bindParam(':rbxid', $rbxid);

        if ($stmt->execute()) {
            $result = $stmt->fetchAll(PDO::FETCH_ASSOC);
            return array('success' => true, 'data' => $result);
        } else {
            return array('success' => false, 'message' => 'Failed to retrieve ban data');
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

$json = file_get_contents('php://input');
$request_data = json_decode($json, true);

$rbxid = $request_data['rbxid'];
$token = $request_data['token'];

$bans_api = new BansAPI();

$result = $bans_api->get_ban_data($token, $rbxid);

header('Content-Type: application/json');
echo json_encode($result);

?>
