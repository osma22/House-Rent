<?php
session_start();
include("connection.php");
$ownerid=$_GET["o"];
$nrooms=$_GET['n'];
$rate=$_GET['ra'];
$add=$_GET['a'];
$desc=$_GET['de'];


if($_GET['submit'])
{
	if($ownerid!="" && $nrooms!="" && $desc!="")
	{
     


		$query="insert into house(owner_id,no_of_rooms,rate,address,description) values('$ownerid','$nrooms','$rate','$add','$desc')";
		$data=mysqli_query($conn,$query);
		
		if($data)

			{
				echo "<script type='text/javascript'>alert('Added successfully')
        window.location.href='houses.php';
        </script>";
	        }
		else
			{
				echo "<script type='text/javascript'>alert('Unsuccessfull')
        window.location.href='houses.php';
        </script>";
			}
	}
}
?>