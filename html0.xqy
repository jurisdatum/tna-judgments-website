xquery version "1.0-ml";

declare variable $uri as xs:string := fn:concat(xdmp:get-request-field('uri'), '.xml');

declare variable $doc as document-node()? := fn:doc($uri);

declare variable $params := map:map()
    => map:with('standalone', fn:true())
    => map:with('image-base', 'https://judgment-images.s3.eu-west-2.amazonaws.com/')
    => map:with('suppress-links', fn:false());

if (fn:exists($doc)) then (
    xdmp:set-response-content-type('text/html'),
    xdmp:xslt-invoke('judgment0.xsl', $doc, $params)

) else (
    xdmp:set-response-code(404, 'Not Found'),
    xdmp:set-response-content-type('text/plain'),
    "Not Found"
)
