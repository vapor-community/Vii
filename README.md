![test](https://github.com/vapor-community/Vii/workflows/test/badge.svg) [![Code Coverage](https://codecov.io/gh/vapor-community/Vii/branch/master/graph/badge.svg)](https://codecov.io/gh/vapor-community/Vii) ![GitHub](https://img.shields.io/github/license/vapor-community/Vii)

# Vii

### Currently in pre-alpha

Extensive changes to fluent currently in progress

Vii is a code generation tool loosely based on Gii from the [Yii](https://github.com/yiisoft/yii2) framework. Vii can quickly reverse engineer a database schema into [Vapor 4](https://github.com/vapor) compatible class definitions, including matching SQL data types to Swift equivalents. Currently, Vii supports Postgres and MySQL. 

## Installation
To start using Vii, clone the repo

```swift
git clone https://github.com/vapor-community/Vii
```

## Usage
cd into the directory of the recently cloned git repo and run the following command.

The basic command is
```swift
swift run Vii <database specifier>
```

There are two current options, `postgres` and `mysql`. 
So to use with Postgres DB.

```swift
swift run Vii postgres
```

## Property Wrappers
The following lists the property wrappers that are currently implemented

## @ID
Any column idenitifed as a `Primary Key` is mapped to the `@ID` property wrapper.

## @Field
Unspecialized columns are mapped to the `@Field` property wrapper.

## @NestedField
Columns declared as `json` are mapped into the  `@NestedField` property wrapper. Vii does not analyze the content of columns, so it is unable to infer the structure of the json. Vapor requires this to be declared. Vii will automatically declare the property of type `UnMappedType`. The user should then replace this declaration with a more fitting one.

## @CompoundField
Vii cannot infer this from a simple scan of the database. Again, the user would have to declare this property type manually

## @Timestamp
Vapor's `@Timestamp` propertyWrapper uses an enum called `Trigger` which helps Fluent determine whether to update this column on creation, update or deletion. Because this is not derivable from the database columns directly, Vii makes an educated guess on what case to apply to the timestamp, this is done based on the column name.

## Initializing Optional Model Properties
Any property that is potentially `Null` in the database will be made optional in the model definition. The initializer's signature will apply them directly as `nil`, rather than omit them eg
```swift
init(id: Int? = nil...)
```

Vii will generate all the models in the specified DB and produce an output folder within the project

### To Implement
- Implement a swift formatter to remove the visual ugliness of escape sequences and make tests and everything else more friendly
- Allow subsection of schema tables to be generated
- Allow skip command to omit comma separated list of tables
- Further support for `@propertyWrappers` as currently not all are implemented and some maybe very hard to implement robustly. I'm looking at you `@Sibling`
- Makes sense to add migrations to the model so users could use their own test DB
- Improved Github workflows to test DBs on Linux with small seeded DB

### Future features
- Look to hook a CRUD builder into it, so you can build standard end points and user repositories

