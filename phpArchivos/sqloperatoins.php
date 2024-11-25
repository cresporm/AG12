<?php
 
$servername = "localhost";
$username = "root";
$password = "";
$dbname = "TestDB";
$table = "Students"; 
 
$action = $_POST["action"];
 

$conn = new mysqli($servername, $username, $password, $dbname);

if($conn->connect_error){
    die("Connection Failed: " . $conn->connect_error);
    return;
} 


if("CREATE_TABLE" == $action){
    $sql = "CREATE TABLE IF NOT EXISTS $table (
        id INT(6) UNSIGNED AUTO_INCREMENT PRIMARY KEY,
        first_name VARCHAR(50) NOT NULL,
        last_name_paterno VARCHAR(50) NOT NULL,
        last_name_materno VARCHAR(50) NOT NULL,
        phone VARCHAR(15) NOT NULL,
        email VARCHAR(100) NOT NULL,
        control_number VARCHAR(15) NOT NULL UNIQUE
    )";

    if($conn->query($sql) === TRUE){
        echo "success";
    } else {
        echo "error";
    }
    $conn->close();
    return;
}


if("SELECT_TABLE" == $action){
    $database_data = array();         
    $sql = "SELECT id, first_name, last_name_paterno, last_name_materno, phone, email, control_number 
            FROM $table ORDER BY id DESC";
    $result = $conn->query($sql);
    
    if($result->num_rows > 0){
        while($row = $result->fetch_assoc()){
            $database_data[] = $row;
        }
        echo json_encode($database_data);
    } else {
        echo "error";
    }
    $conn->close();
    return;
}


if("INSERT_DATA" == $action){
    $first_name = strtoupper($_POST["first_name"]);
    $last_name_paterno = strtoupper($_POST["last_name_paterno"]);
    $last_name_materno = strtoupper($_POST["last_name_materno"]);
    $phone = $_POST["phone"];
    $email = $_POST["email"];
    $control_number = $_POST["control_number"];
    
   
    $check_sql = "SELECT control_number FROM $table WHERE control_number = '$control_number'";
    $check_result = $conn->query($check_sql);
    if($check_result->num_rows > 0){
        echo "exists";
        $conn->close();
        return;
    }

    $sql = "INSERT INTO $table (first_name, last_name_paterno, last_name_materno, phone, email, control_number) 
            VALUES ('$first_name', '$last_name_paterno', '$last_name_materno', '$phone', '$email', '$control_number')";
    
    if($conn->query($sql) === TRUE){
        echo "success";
    } else {
        echo "error";
    }
    $conn->close();
    return;
}


if("CHECK_CONTROL_NUMBER" == $action){
    $control_number = $_POST["control_number"];
    $sql = "SELECT control_number FROM $table WHERE control_number = '$control_number'";
    $result = $conn->query($sql);
    
    if($result->num_rows > 0){
        echo "true";
    } else {
        echo "false";
    }
    $conn->close();
    return;
}

?>
