<?
// Check for required header and POST data before continuing
$headerApiKey = $_SERVER['HTTP_X_API_KEY'];

if (empty($_POST['id']) ||
    empty($_POST['t']) ||
    empty($_POST['h']) ||
    $headerApiKey !== 'XXXX') {
  die();
}

require 'vendor/autoload.php';

use Medoo\Medoo;

$sensor_id = (string) $_POST['id'];
$temperature = (float) $_POST['t'];
$humidity = (float) $_POST['h'];

$database = new Medoo([
  'database_type' => 'mysql',
  'database_name' => 'ffxiatla_temp_sensor',
  'server' => 'localhost',
  'username' => 'XXXX',
  'password' => 'XXXX'
]);

$database->insert('temperature', [
  'sensor' => $sensor_id,
  'temperature' => $temperature,
  'humidity' => $humidity
]);

echo 'OK';