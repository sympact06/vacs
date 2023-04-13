<?php
// First, we need to connect to the database using PDO:
$db_host = 'localhost';
$db_name = 'sympactn_db_vacs';
$db_user = 'sympactn_db_vacs';
$db_pass = '9pjSqntA';

$pdo = new PDO("mysql:host=$db_host;dbname=$db_name", $db_user, $db_pass);

// Now we can build the query to check if the server ID exists and has a valid renewal date:
$sql = "SELECT COUNT(*) FROM `users` WHERE `server_id` = :server_id AND `renewal_date` > NOW()";

$stmt = $pdo->prepare($sql);
$stmt->bindParam(':server_id', $_GET['serverid']);
$stmt->execute();

$count = $stmt->fetchColumn();

// Finally, we can return the appropriate response based on the query results:
if ($count > 0) {
    echo "true";
} else {
    echo "false";
}
