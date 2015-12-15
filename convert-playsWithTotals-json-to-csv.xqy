xquery version "3.1";

declare namespace xpf = "http://www.w3.org/2005/xpath-functions";

(: Connects to the Comédie Française registers, converts JSON data to XML, and serializes as CSV  :)

declare function local:convert-plays($map as element()) as element()
{
  element play {
    element id {$map/xpf:number[@key="id"]/text()},
    element total {$map/xpf:number[@key="total"]/text()},
    element title {$map/xpf:string[@key="title"]/text()}
  }
};

let $base-url := "http://api.cfregisters.org/"
let $data-url := $base-url || "plays_with_totals"
let $data := fetch:text($data-url)
let $raw-xml := fn:json-to-xml($data)
let $plays := element plays {
   for $map in $raw-xml/xpf:array/xpf:map
   return local:convert-plays($map) }
return csv:serialize($plays, map { 'header': true() })
