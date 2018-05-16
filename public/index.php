<?php

use Slim\Exception\MethodNotAllowedException;
use Slim\Exception\NotFoundException;
use Tevun\Hello;

require dirname(__DIR__) . '/vendor/autoload.php';

$app = new Slim\App;

$app->get('/', Hello::class);

try {
    $app->run();
} catch (MethodNotAllowedException $e) {
    error_log($e);
} catch (NotFoundException $e) {
    error_log($e);
} catch (Exception $e) {
    error_log($e);
}
