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

    public function get_ban_data( $rbxid) {
    
        $stmt = $this->db->prepare("SELECT * FROM bans WHERE rbxid = :rbxid");

        $stmt->bindParam(':rbxid', $rbxid);

        if ($stmt->execute()) {
            if ($stmt->rowCount() > 0) {
                return "Banned";
            } else {
                return "No ban found";
            }
        } else {
            return "Error";
        }

    

    }
}


$rbxid = $_GET['rbxid'];

$bans_api = new BansAPI();

$result = $bans_api->get_ban_data($rbxid);
echo $result;


?>
