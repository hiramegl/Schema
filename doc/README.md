# Schema

## Tool for creating schemas for systems using aspect oriented architecture

Features:
+ schema sets & version of sets
  - authorizations
  - validations
  - units
  - enumerations
+ schemas & version of schemas
  - attributes
+ dependencies between schemas / shared definitions & components between schemas
+ deployment of schemas


## Backlog
1. generation of schema yaml/javascript
1. fix selection of a schema version -> display schema, references and elements
1. fix boxes for schemas instead of circles
1. fix edges between schemas to show relationships
1. implement upgrade function for set/set-element/component versions
1. forbid to add primitives and children before saving the component version
1. Rename logic/presentation -> frontend/backend
1. change backend to use merklets instead of tables
1. add middle layer in frontend to have a progressive web application (use local storage & merklets & sync with backend)
