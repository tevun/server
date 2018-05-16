<?php

use ArangoDBClient\Collection;
use ArangoDBClient\CollectionHandler;
use ArangoDBClient\Connection;
use ArangoDBClient\ConnectionOptions;
use ArangoDBClient\Document;
use ArangoDBClient\DocumentHandler;
use ArangoDBClient\Exception;
use ArangoDBClient\Statement;
use ArangoDBClient\UpdatePolicy;

require dirname(__DIR__) . '/vendor/autoload.php';

$options = [
    ConnectionOptions::OPTION_ENDPOINT => 'tcp://tevun-arango:8529',
    ConnectionOptions::OPTION_AUTH_TYPE => 'Basic',
    ConnectionOptions::OPTION_AUTH_USER => 'root',
    ConnectionOptions::OPTION_AUTH_PASSWD => '',
    ConnectionOptions::OPTION_CONNECTION => 'Close',
    ConnectionOptions::OPTION_TIMEOUT => 3,
    ConnectionOptions::OPTION_RECONNECT => true,
    ConnectionOptions::OPTION_CREATE => true,
    ConnectionOptions::OPTION_UPDATE_POLICY => UpdatePolicy::LAST,
];

// open connection
try {
    $connection = new Connection($options);

    // create a new collection
    $collectionName = "firstCollection";
    $collection = new Collection($collectionName);
    $collectionHandler = new CollectionHandler($connection);

    if ($collectionHandler->has($collectionName)) {
        // drops an existing collection with the same name to make
        // tutorial repeatable
        $collectionHandler->drop($collectionName);
    }

    $collectionId = $collectionHandler->create($collection);
    $documentHandler = new DocumentHandler($connection);

    echo "<pre>";

    var_dump($collectionId);

    // create a document with some attributes
    $document = new Document();
    $document->set("a", "Foo");
    $document->set("b", "bar");

    // save document in collection
    $documentId = $documentHandler->save($collectionName, $document);

    // execute AQL queries
    $query = 'FOR x IN firstCollection RETURN x._key';
    $statement = new Statement(
        $connection,
        [
            "query" => $query,
            "count" => true,
            "batchSize" => 1000,
            "sanitize" => true
        ]
    );

    $cursor = $statement->execute();
    $resultingDocuments = [];

    foreach ($cursor as $key => $value) {
        $resultingDocuments[$key] = $value;
    }

    var_dump($resultingDocuments);

    // read document
    $document = $documentHandler->get($collectionName, $documentId);
    var_dump($document);

    // update document
    $document->set("c", "qux");
    $documentHandler->update($document);

    // read document again
    $document = $documentHandler->get($collectionName, $documentId);
    var_dump($document);

    // additional data via for-loop
    for ($i = 0; $i < 100; $i++) {
        $document = new Document();
        $document->set("_key", "doc_" . $i . mt_rand());
        $val = false;
        if ($i % 2 === 0) {
            $val = true;
        }
        $document->set("even", $val);
        $documentHandler->save($collectionName, $document);
    }

    // list all documents
    $documents = $collectionHandler->all($collectionId);

    var_dump($documents);

    // remove
    $documentDelete = $documentHandler->remove($document);
    var_dump($documentDelete);
} catch (Exception $e) {
    error_log($e);
}
