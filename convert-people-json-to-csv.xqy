xquery version "3.1";

declare namespace xpf = "http://www.w3.org/2005/xpath-functions";

(: Connects to the Comédie Française registers, converts JSON data to XML, and (optionally) persists documents to BaseX database  :)

declare function local:convert-people($map as element()) as element()
{
  element person {
    attribute created {$map/xpf:string[@key="created_at"]/text()},
    attribute updated {$map/xpf:string[@key="updated_at"]/text()},
    element id {$map/xpf:number[@key="id"]/text()},
    element dates {$map/xpf:string[@key="dates"]/text()},
    element url {$map/xpf:string[@key="url"]/text()},
    element firstName {$map/xpf:string[@key="first_name"]/text()},
    element lastName {$map/xpf:string[@key="last_name"]/text()},
    element fullName {$map/xpf:string[@key="full_name"]/text()},
    element pseudonym {$map/xpf:string[@key="pseudonym"]/text()},
    element honorific {$map/xpf:string[@key="honorific"]/text()},
    element alias {$map/xpf:string[@key="alias"]/text()},
    element societairePensionnaire {$map/xpf:string[@key="societaire_pensionnaire"]/text()}
  }
  
};

let $base-url := "http://api.cfregisters.org/"
let $people-url := $base-url || "people"
let $people-data := fetch:text($people-url)
let $raw-xml := fn:json-to-xml($people-data)
let $people := element people {
   for $map in $raw-xml/xpf:array/xpf:map
   return local:convert-people($map) }
return csv:serialize($people, map { 'header': true() })
