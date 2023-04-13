<?php

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

    public function get_ban_data($token, $rbxid) {
        // Check if the token is valid
        if (!$this->is_token_valid($token)) {
            return array('success' => false, 'message' => 'Invalid token');
        }

        // Prepare the SQL statement to retrieve the ban data for the given rbxid
        $stmt = $this->db->prepare("SELECT * FROM bans WHERE rbxid = :rbxid");

        // Bind the rbxid parameter to the statement
        $stmt->bindParam(':rbxid', $rbxid);

        // Execute the statement and check if there is bandata found then return the bandata
        if ($stmt->execute()) {
            if ($stmt->rowCount() > 0) {
                $ban_data = $stmt->fetch(PDO::FETCH_ASSOC);
                return array('success' => true, 'message' => 'Banned', 'ban_data' => $ban_data);
            } else {
                return array('success' => false, 'message' => 'No ban found');
            }
        } else {
            return array('success' => false, 'message' => 'Error');
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

// Retrieve the POST data from the request
$json = file_get_contents('php://input');
$request_data = json_decode($json, true);

// Extract the required parameters from the request data
$rbxid = $request_data['rbxid'];
$token = $request_data['token'];

// Create a new instance of the BansAPI class
$bans_api = new BansAPI();

// Call the get_ban_data method to retrieve the ban data
$result = $bans_api->get_ban_data($token, $rbxid);

// Output the result as JSON
header('Content-Type: application/json');
echo json_encode($result);

?>
