## [Unreleased]

## [0.4.0] - 2022-01-09
### Feature
- Better support for `ArgumentError` on `FlexStruct`

## [0.3.3] - 2022-01-05
### Fix
- Support false values correctly, instead of returning nil
- Support `respond_to?` properly on `FlexStruct`

## [0.3.2] - 2022-01-05
### Fix
- Support for proper marshalling of object

## [0.3.1] - 2022-01-05
### Fix
- Support nil meaning empty hash as first argument to `FlexStruct` and `StrictStruct`

## [0.3.0] - 2022-01-04
### Feature
- Support for `as_json` and `to_json`
- Support for `#[]=`, allowing modification on LooseStruct
- Support for `JSON.parse(STR, object_class: ResourceStruct::FlexStruct)`
- Refactor common code between LooseStruct and FirmStruct into `ResourceStruct::Extension::IndifferentLookup`
- No longer support wrong arity for method based access patterns
- Rename `LooseStruct` -> `FlexStruct`; `FirmStruct` -> `StrictStruct`

## [0.2.1] - 2022-01-01
### Fix
- Correct handling of #== operator on Structs with hashes

## [0.2.0] - 2022-01-01
### Changed
- Indifferent access support for input hash (support for symbol-based hashes in initializer)

## [0.1.0] - 2021-12-14

- Initial release
