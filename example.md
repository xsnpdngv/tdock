---
title: Docs-as-Code Proof-of-Concept
author: Tamás Dezső
date: \today
numbersections: true
toc: true
lof: true
lot: true
# mainfont: "DejaVu Sans"
# monofont: "DejaVu Mono"
# fontsize: 10pt
---

# Introduction

This document validates the `tdock` isolated technical documentation
build environment. It tests standard markdown rendering, syntax
highlighting for various languages, and the automatic vectorization of
diagrams.

For the capabilities of the underlying Markdown engine, see the official
**Pandoc:**
[The Universal Document Converter](https://pandoc.org/MANUAL.html)
documentation. [Pandoc Examples](https://pandoc.org/demos.html) is also
worth a check.


# Styling

We support standard styling:

- **Bold text** for emphasis.
- *Italic text* for terminology.
- ***Bold-Italic*** for critical notes.
- `Monospaced code` for inline commands.


# Tables

Tables are essential for documenting interface parameters or service
specifications.

| Interface | Protocol | Latency Target | Priority |
|:----------|:---------|:---------------|:---------|
| Gx        | Diameter | < 50ms         | High     |
| Ro        | Diameter | < 100ms        | Medium   |
| SIP       | UDP/TCP  | < 30ms         | High     |

: Service Interface Specifications 


# Mathematical Notation

For complex charging algorithms, we use standard LaTeX math support:

The transaction cost $C$ is calculated as:
$$C = \sum_{i=1}^{n} (t_i \times r_i) + \text{tax}$$


# Code-Blocks

By default, syntax highlighting uses the `tango` theme. The font should
map to the Google/Ubuntu fonts requested in the YAML frontmatter.


## C/C++

```c
#include <stdio.h>

typedef struct {
    int transaction_id;
    char status[16];
} Session;

int main() {
    Session s = {1042, "ACTIVE"};
    printf("Session %d is %s\n", s.transaction_id, s.status);
    return 0;
}
```


## Lua

```lua
function check_node(elem)
  if elem.t == "CodeBlock" then
    return pandoc.RawBlock("html", "<!-- Code Block Exists -->")
  end
end
```


## Bash

```bash
#!/bin/bash
echo "Starting compilation..."
mkdir -p build && cd build
cmake .. && make
```

## Python

```python
def fibonacci(n):
    if n <= 0:
        return []
    elif n == 1:
        return [0]
    elif n == 2:
        return [0, 1]
    else:
        seq = [0, 1]
        for i in range(2, n):
            seq.append(seq[-1] + seq[-2])
        return seq
```


# Automated Diagrams

The blocks below are automatically parsed by the Pandoc diagram Lua
filter, rendered via their respective engines, and embedded perfectly
into the PDF using XeLaTeX.

On GitHub, Mermaid code-blocks are automatically rendered, and plantUML
blocks can be visualized too with the
[PlantUML for GitHub Chrome Extension](https://github.com/plantuml/plantuml-for-github)


## PlantUML

- [Website](https://plantuml.com/)
- [Language Reference Guide](https://plantuml.com/en/guide)
- [Style Guide](https://plantuml.com/style-evolution)

This is an example reference to Figure \ref{fig:sde}.

```plantuml
'| caption: PlantUML Sequence Diagram Example
'| width: 70%
'| placement: H
'| label: fig:sde
@startuml
title Client-Server Interaction

participant "Client" as C
participant "Server" as S
participant "Database" as DB

C->S: XY Request
activate S
note right of C
    details of the request:
    - detail 1
    - detail 2
end note

note over S
    Check request
end note

loop Until set successfully OR number of retries reaches 3

S->DB: Get Record Request
activate DB
DB-->S: Get Record Reply
deactivate DB

note over S
    Read data from the record
end note

opt If condition 1 is not met
    S-->C: XY Response (not done, condition 1 is not met)
    note over S
        Terminate
    end note
end

note over S
    Compile database record
    according to the request
end note

S->DB: Set Record Request
activate DB
DB-->S: Set Record Reply
deactivate DB

end loop

alt If not set successfully
    S-->C: XY Response (not done, version mismatch)
else
    S-->C: XY Response (done)
    deactivate S
    destroy S
end
@enduml
```

---

```plantuml
@startjson
'| caption: PlantUML Json Diagram Example
'| width: 70%
'| placement: H
'| label: fig:jde
#highlight "lastName"
#highlight "address" / "city"
#highlight "phoneNumbers" / "0" / "number"
{
  "firstName": "John",
  "lastName": "Smith",
  "isAlive": true,
  "age": 28,
  "address": {
    "streetAddress": "21 2nd Street",
    "city": "New York",
    "state": "NY",
    "postalCode": "10021-3100"
  },
  "phoneNumbers": [
    {
      "type": "home",
      "number": "212 555-1234"
    },
    {
      "type": "office",
      "number": "646 555-4567"
    }
  ],
  "children": [],
  "spouse": null
}
@endjson
```

---

```plantuml
@startuml
'| caption: PlantUML Activity Diagram Example
'| width: 25%
'| placement: H
'| label: fig:ade
title Generating Diagrams
start
repeat
  :read data;
  :generate diagrams;
repeat while (more data?) is (yes) not (no)
stop
@enduml
```

---

```plantuml
'| caption: PlantUML Class Diagram Example
'| width: 40%
'| placement: H
'| label: fig:cde
@startuml
title Aaa Class Diagram
class Aaa {
    -bbb : int
    +ccc : string
    #aa : float
    +void addEntry(mmm : Entry)
    +int setFactory(ddd : string)
}
class Factory {
    #fff : string
}
class Entry {
    -yyy : int
}
class Parent {
}
Aaa *--> "1..100" Entry : -entries
Aaa o--> Factory : #factory
Aaa o--> Parent : +parent
@enduml
```

---

```plantuml
'| caption: PlantUML EBNF Diagram Example
'| width: 50%
'| placement: H
'| label: fig:ede
@startebnf
title Syntax Definition
not_styled_ebnf = {"a", c , "a" (* Note on a *)}
| ? special ?
| "repetition", 4 * '2';
(* Global End Note *)
@endebnf
```


## Mermaid

- [Mermaid Open-Source Intro](https://mermaid.ai/open-source/intro/)

```mermaid
%%| caption: Mermaid Flowchart Example
%%| label: fig:mmm
%%| width: 60%
%%| placement: H
%%{init: {'theme': 'neutral'}}%%
graph TD;
    idle([Idle])
    idle --> req>Request]
    req  --> chk{{Check}}
    chk  -->|Valid| proc[[Process]]
    chk  -->|Invalid| err[[Handle Error]]
    proc --> respOk[Send OK Response]
    respOk --> open([Open])
    open --> done@{ shape: cross-circ }
    err  --> respErr[Send Error Response]
    respErr  --> term@{ shape: cross-circ }
```


## Graphviz/DOT

- [DOT Language Specification](https://graphviz.org/doc/info/lang.html)
- [Gallery](https://graphviz.org/gallery/)

```dot
//| caption: Graphviz/DOT Diagram Example
//| label: fig:dot
//| width: 30%
//| placement: H
digraph G {
    node [shape=box, fontname="DejaVu Sans"];
    edge [fontname="DejaVu Sans"];

    Controller -> Dispatcher;
    Dispatcher -> Worker1;
    Dispatcher -> Worker2;
    Worker1 -> Database;
    Worker2 -> Database;
}
```
