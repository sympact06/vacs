<?php

// error logging all
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

date_default_timezone_set('Europe/Amsterdam');


class BansAPI {
    private $db;

    public function __construct() {
        // Connect to the database
        $db_host = 'localhost';
        $db_name = 'sympactn_db_vacs';
        $db_user = 'sympactn_db_vacs';
        $db_pass = '9pjSqntA';
        $this->db = new PDO("mysql:host=$db_host;dbname=$db_name", $db_user, $db_pass);
    }

    public function add_ban($token, $ban_type, $reason, $rbxid) {
        // Check if the bearer key is valid


        // Check if the token is valid
        if (!$this->is_token_valid($token)) {
            return array('success' => false, 'message' => 'Invalid token');
        }

        // Prepare the SQL statement to insert a new ban
        $stmt = $this->db->prepare("INSERT INTO bans (ban_type, banned_at, reason, rbxid) VALUES (:ban_type, :banned_at, :reason, :rbxid)");
        $banned_at = date('Y-m-d H:i:s');

        // Bind the parameters to the statement
        $stmt->bindParam(':ban_type', $ban_type);
        $stmt->bindParam(':banned_at', $banned_at);
        $stmt->bindParam(':reason', $reason);
        $stmt->bindParam(':rbxid', $rbxid);

        // Execute the statement and check if the insert was successful
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

// Get the JSON data from the request
$json_data = file_get_contents('php://input');

// Decode the JSON data into an associative array
$data = json_decode($json_data, true);

// Check if the necessary data is present
if (!isset($data['token']) || !isset($data['ban_type']) || !isset($data['reason']) || !isset($data['rbxid'])) {
    // Return an error response if the necessary data is not present
    $response = array('success' => false, 'message' => 'Invalid input data');
    echo json_encode($response);
    exit;
}

// Get the necessary data from the input
$token = $data['token'];
$ban_type = $data['ban_type'];
$reason = $data['reason'];
$rbxid = $data['rbxid'];

// Create a new instance of the BansAPI class
$bans_api = new BansAPI();

// Call the add_ban method with the input data
$response = $bans_api->add_ban($token, $ban_type, $reason, $rbxid);

// Return the response as JSON
echo json_encode($response);
?>
