<?php
	include 'connected.php';
	header("Access-Control-Allow-Origin: *");

if (!$link) {
    echo "Error: Unable to connect to MySQL." . PHP_EOL;
    echo "Debugging errno: " . mysqli_connect_errno() . PHP_EOL;
    echo "Debugging error: " . mysqli_connect_error() . PHP_EOL;
    
    exit;
}

if (!$link->set_charset("utf8")) {
    printf("Error loading character set utf8: %s\n", $link->error);
    exit();
	}

if (isset($_GET)) {
	if ($_GET['isAdd'] == 'true') {
				
		$idUser = $_GET['idUser'];
		$idOffice = $_GET['idOffice'];
		$dataCheck = $_GET['dataCheck'];
		$checkIn = $_GET['checkIn'];
		
		
		
							
		$sql = "INSERT INTO `officerCheckInOut`(`id`, `idUser`, `idOffice`, `dataCheck`, `checkIn`, `checkOut`) VALUES (Null,'$idUser','$idOffice','$dataCheck','$checkIn','')";

		$result = mysqli_query($link, $sql);

		if ($result) {
			echo "true";
		} else {
			echo "false";
		}

	} else echo "Welcome Master UNG";
   
}
	mysqli_close($link);
?>