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
1. fix selection of a schema version -> display schema, references and elements
1. forbid to add primitives and children before saving the component version
1. fix boxes for schemas instead of circles
1. fix edges between schemas to show relationships
1. implement upgrade function for set/set-element/component versions
1. Rename logic/presentation -> frontend/backend
1. change backend to use merklets instead of tables
1. add middle layer in frontend to have a progressive web application (use local storage & merklets & sync with backend)

- Index Set
- #Info (Name, Doc)
- #Ref (Name, Version)
- #Entry (Value, Doc)
- Set (Info | Idx?)
  - [@0] SetVersion ([1.] Info | Deploy?)
      - [@0] Schema (Info)
        - [@0] SchemaVersion ([1.] Info | Deploy?)
          - [@0] SchemaRef ([1.] Ref)
          - [@0] AuthorizationRef ([1.] Ref)
          - [@0] ValidationRef ([1.] Ref)
          - [@0] UnitRef ([1.] Ref)
          - [@0] EnumerationRef ([1.] Ref)
          - [@0] Component ([1.] Info)
            - [@0] ComponentVersion ([1.] Info)
                - [@0] Primitive ([1.] Info, Class, Version, Nullable, ValidRef, UnitRef, EnumRef)
                - [@0] Child (CompRef, Array, Nullable)
      - [@0] Authorization ([1.] Info)
        - [@0] AuthVersion ([1.] Info | Url?)
      - [@0] Validation ([1.] Info)
        - [@0] ValidVersion ([1.] Info | Url?)
      - [@0] Unit ([1.] Info)
        - [@0] UnitVersion ([1.] Info | Url?)
      - [@0] Enumeration ([1.] Info)
        - [@0] EnumVersion ([1.] Info | Url?)
          - [@.] Entry
