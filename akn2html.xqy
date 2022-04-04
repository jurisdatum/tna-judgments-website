xquery version "1.0-ml";

let $akn := xdmp:get-request-body('xml')

return if (xdmp:get-request-method() = 'POST') then (
    xdmp:add-response-header('Access-Control-Allow-Origin', '*'),
    xdmp:add-response-header('Access-Control-Allow-Methods', 'OPTIONS, POST'),
    xdmp:add-response-header('Access-Control-Allow-Headers', 'Content-Type'),
    xdmp:set-response-content-type('text/html'),
    xdmp:xslt-invoke('judgment0.xsl', $akn)
) else (
    xdmp:add-response-header('Access-Control-Allow-Origin', '*'),
    xdmp:add-response-header('Access-Control-Allow-Methods', 'OPTIONS, POST'),
    xdmp:add-response-header('Access-Control-Allow-Headers', 'Content-Type')
)
