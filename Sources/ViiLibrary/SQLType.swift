struct SQLType: Equatable {
    let dataType: String

    init(_ dataType: String) {
        self.dataType = dataType
    }

    // standard types
    static var bigInt: SQLType {
        return .init("bigint")
    }
    static var bit: SQLType {
        return .init("bit")
    }
    static var boolean: SQLType {
        return .init("boolean")
    }
    static var bool: SQLType {
        return .init("bool")
    }
    static var box: SQLType {
        return .init("box")
    }
    static var bpchar: SQLType {
        return .init("bpchar")
    }
    static var bytea: SQLType {
        return .init("bytea")
    }
    static var char: SQLType {
        return .init("char")
    }
    static var date: SQLType {
        return .init("date")
    }
    static var dateTime: SQLType {
        return .init("datetime")
    }
    static var dec: SQLType {
        return .init("dec")
    }
    static var decimal: SQLType {
        return .init("decimal")
    }
    static var double: SQLType {
        return .init("double")
    }
    static var float: SQLType {
        return .init("float")
    }
    static var float4: SQLType {
        return .init("float4")
    }
    static var float8: SQLType {
        return .init("float8")
    }
    static var int: SQLType {
        return .init("int")
    }
    static var int2: SQLType {
        return .init("int2")
    }
    static var int4: SQLType {
        return .init("int4")
    }
    static var int8: SQLType {
        return .init("int8")
    }
    static var json: SQLType {
        return .init("json")
    }
    static var jsonb: SQLType {
        return .init("jsonb")
    }
    static var longText: SQLType {
        return .init("longtext")
    }
    static var mediumInt: SQLType {
        return .init("mediumint")
    }
    static var mediumText: SQLType {
        return .init("mediumtext")
    }
    static var money: SQLType {
        return .init("money")
    }
    static var numeric: SQLType {
        return .init("numeric")
    }
    static var point: SQLType {
        return .init("point")
    }
    static var polygon: SQLType {
        return .init("polygon")
    }
    static var text: SQLType {
        return .init("text")
    }
    static var time: SQLType {
        return .init("time")
    }
    static var tinyInt: SQLType {
        return .init("tinyInt")
    }
    static var tinyText: SQLType {
        return .init("tinytext")
    }
    static var smallInt: SQLType {
        return .init("smallint")
    }
    static var timestamp: SQLType {
        return .init("timestamp")
    }
    static var timestampz: SQLType {
        return .init("timestampz")
    }
    static var uuid: SQLType {
        return .init("uuid")
    }
    static var varbit: SQLType {
        return .init("varbit")
    }
    static var varchar: SQLType {
        return .init("varchar")
    }
    static var xml: SQLType {
        return .init("xml")
    }
    static var year: SQLType {
        return .init("year")
    }

    // Array Types
    static var _bit: SQLType {
        return .init("_bit")
    }
    static var _bool: SQLType {
        return .init("_bool")
    }
    static var _bpchar: SQLType {
        return .init("_bpchar")
    }
    static var _bytea: SQLType {
        return .init("_bytea")
    }
    static var _char: SQLType {
        return .init("_char")
    }
    static var _float4: SQLType {
        return .init("_float4")
    }
    static var _float8: SQLType {
        return .init("_float8")
    }
    static var _int2: SQLType {
        return .init("_int2")
    }
    static var _int4: SQLType {
        return .init("_int4")
    }
    static var _int8: SQLType {
        return .init("_int8")
    }
    static var _json: SQLType {
        return .init("_json")
    }
    static var _jsonb: SQLType {
        return .init("_jsonb")
    }
    static var _money: SQLType {
        return .init("_money")
    }
    static var _numeric: SQLType {
        return .init("_numeric")
    }
    static var _text: SQLType {
        return .init("_text")
    }
    static var _uuid: SQLType {
        return .init("_uuid")
    }
    static var _varbit: SQLType {
        return .init("_varbit")
    }
    static var _xml: SQLType {
        return .init("_xml")
    }

    var swiftType: String {
        switch self {
        case .bit, .bpchar, .bytea, .varbit, ._bit, ._bpchar, ._bytea, ._varbit: return "Data"
        case .bool, .boolean, ._bool: return "Bool"
        case .box, .point, .polygon: return "/* Defaulted to String as Postgres geometric types are unsupported*/String"
        case .char, .mediumText, .longText, .text, .tinyText, .varchar, ._char, ._text: return "String"
        case .dec, .decimal, .double, .money, .numeric, ._money, ._numeric: return "Double"
        case .date, .dateTime, .time, .timestamp, .timestampz: return "Date"
        case .float, .float4, .float8, ._float4, ._float8: return "Float"
        case .int, .int2, .int4, .int8, .tinyInt, .smallInt, .mediumInt,
             .bigInt, .year, ._int2, ._int4, ._int8: return "Int"
        case .json, ._json, ._jsonb: return "JSON"
        case .jsonb: return "JSON"
        case .uuid, ._uuid: return "UUID"
        case .xml, ._xml: return "XML"
        default: return "/* Defaulted to String as couldn't map type*/String"
        }
    }

    static let foundationRequired: [SQLType] = [
                                                .uuid, ._uuid, .json, .jsonb, .xml, .date, .dateTime,
                                                .time, .timestamp, .timestampz, .bit, .bytea, .varbit
                                               ]
    static let timestampable: [SQLType] = [.date, .dateTime, .time, .timestamp, .timestampz]
    static let potsgresArray: [SQLType] = [
                                             ._bool, ._bit, ._bpchar, ._bytea, ._varbit, ._char,
                                             ._float4, ._float8, ._int2, ._int4, ._int8, ._json,
                                             ._jsonb, ._money, ._numeric, ._text, ._uuid, ._xml
                                          ]
}
