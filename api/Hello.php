<?php

namespace Tevun;

use Psr\Http\Message\ServerRequestInterface as Request;
use Psr\Http\Message\ResponseInterface as Response;

/**
 * Class Hello
 * @package Tevun
 */
class Hello
{
    /**
     * The __invoke method is called when a script tries to call an object as a function.
     *
     * @param Request $request
     * @param Response $response
     * @param array $args
     * @return mixed
     * @link http://php.net/manual/en/language.oop5.magic.php#language.oop5.magic.invoke
     * @SuppressWarnings(Unused)
     */
    public function __invoke(Request $request, Response $response, array $args)
    {
        $response->getBody()->write("<h1>tevun <small>--help</small></h1>");
        return $response;
    }
}