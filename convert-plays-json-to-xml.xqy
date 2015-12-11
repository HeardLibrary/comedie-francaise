xquery version "3.1";

declare namespace xpf = "http://www.w3.org/2005/xpath-functions";

(: Connects to the Comédie Française registers, converts JSON data to XML, and (optionally) persists documents to BaseX database  :)

declare function local:convert-play($map as element()) as element()
{
  element play {
    attribute id {$map/xpf:number[@key="id"]/text()},
    if ($map/xpf:string[@key="created_at"]) then attribute created {$map/xpf:string[@key="created_at"]/text()} else (),
    if ($map/xpf:string[@key="updated_at"]) then attribute updated {$map/xpf:string[@key="updated_at"]/text()} else (),
    if ($map/xpf:string[@key="expert_validated"]) then attribute validated {$map/xpf:string[@key="expert_validated"]/text()} else (),
    if ($map/xpf:string[@key="musique_danse_machine"]) then attribute musique-danse-machine {$map/xpf:string[@key="musique_danse_machine"]/text()} else (),
    if ($map/xpf:string[@key="_packed_id"]) then attribute packed {$map/xpf:string[@key="_packed_id"]/text()} else (),
    if ($map/xpf:string[@key="author"]/text()) then element author {$map/xpf:string[@key="author"]/text()} else (),
    if ($map/xpf:string[@key="title"]/text()) then element title {$map/xpf:string[@key="title"]/text()} else (),
    if ($map/xpf:string[@key="date_de_creation"]/text()) then element date {$map/xpf:string[@key="date_de_creation"]/text()} else (),
    if ($map/xpf:string[@key="url"]/text()) then element url {$map/xpf:string[@key="url"]/text()} else (),
    if ($map/xpf:string[@key="alternative_title"]/text()) then element alternative-title {$map/xpf:string[@key="alternative-title"]/text()} else (),
    if ($map/xpf:string[@key="genre"]/text()) then element genre {$map/xpf:string[@key="genre"]/text()} else (),
    if ($map/xpf:string[@key="acts"]/text()) then element acts {$map/xpf:string[@key="acts"]/text()} else (),
    if ($map/xpf:string[@key="prose_vers"]/text()) then element style {$map/xpf:string[@key="prose_vers"]/text()} else (),
    if ($map/xpf:string[@key="prologue"]/text()) then element  prologue {$map/xpf:string[@key="prologue"]/text()} else ()
  }
  
};

let $base-url := "http://api.cfregisters.org/"
let $plays-url := $base-url || "plays"
let $plays := fetch:text($plays-url)
let $raw-xml := fn:json-to-xml($plays)
return 
 for $map in $raw-xml/xpf:array/xpf:map
 return local:convert-play($map) (:  db:add($db, local:convert-play($map), $map/xpf:number[@key="id"]/text() || ".xml") :)
