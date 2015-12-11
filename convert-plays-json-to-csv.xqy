xquery version "3.1";

declare namespace xpf = "http://www.w3.org/2005/xpath-functions";

(: Connects to the Comédie Française registers, converts JSON data to XML, and serializes as CSV  :)

declare function local:convert-play($map as element()) as element()
{
  element play {
    attribute id {$map/xpf:number[@key="id"]/text()},
    attribute created {$map/xpf:string[@key="created_at"]/text()},
    attribute updated {$map/xpf:string[@key="updated_at"]/text()},
    attribute validated {$map/xpf:string[@key="expert_validated"]/text()},
    attribute musique-danse-machine {$map/xpf:string[@key="musique_danse_machine"]/text()},
    attribute packed {$map/xpf:string[@key="_packed_id"]/text()},
    element author {$map/xpf:string[@key="author"]/text()},
    element title {$map/xpf:string[@key="title"]/text()},
    element date {$map/xpf:string[@key="date_de_creation"]/text()},
    element url {$map/xpf:string[@key="url"]/text()},
    element alternative-title {$map/xpf:string[@key="alternative-title"]/text()},
    element genre {$map/xpf:string[@key="genre"]/text()},
    element acts {$map/xpf:string[@key="acts"]/text()},
    element style {$map/xpf:string[@key="prose_vers"]/text()},
    element  prologue {$map/xpf:string[@key="prologue"]/text()}
  }
};

let $base-url := "http://api.cfregisters.org/"
let $plays-url := $base-url || "plays"
let $plays := fetch:text($plays-url)
let $raw-xml := fn:json-to-xml($plays)
let $plays := element plays {
   for $map in $raw-xml/xpf:array/xpf:map
   return local:convert-play($map) }
return csv:serialize($plays, map { 'header': true() })
