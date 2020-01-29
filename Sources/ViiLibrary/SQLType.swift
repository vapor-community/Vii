struct SQLType: Equatable {
    let dataType: String
    
    init(_ dataType: String){
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
    static var float4: SQLType {
        return .init("float4")
    }
    static var float8: SQLType {
        return .init("float8")
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
        return .init("varchar")
    }
    static var year: SQLType {
        return .init("year")
    }
    
    // Array Types
    static var _bool: SQLType {
        return .init("_bool")
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
    static var _text: SQLType {
        return .init("_text")
    }
    static var _uuid: SQLType {
        return .init("_uuid")
    }
    
    var swiftType: String {
        switch self {
        case .bit: return "XXX"
        case .bool, .boolean: return "Bool"
        case .box: return "XXX"
        case .bpchar, .char, .mediumText, .longText, .text, .tinyText, .varchar: return "String"
        case .bytea: return "XXX"
        case .dec, .decimal, .double, .money, .numeric: return "Double"
        case .date, .dateTime: return "Date"
        case .float4, .float8: return "Float"
        case .int2, .int4, .int8, .tinyInt, .smallInt, .mediumInt, .bigInt: return "Int"
        case .json: return "JSON"
        case .jsonb: return "JSON"
        case .point: return "XXX"
        case .polygon: return "XXX"
        case .time: return "XXX"
        case .timestamp: return "KEYPATH"
        case .timestampz: return "KEYPATH"
        case .uuid: return "UUID"
        case .varbit: return "XXX"
        case .xml: return "XXX"
        case .year: return "XXX"
        // array switch
        case ._bool: return "[Bool]"
        case ._bytea: return "[bytea]"
        case ._char: return "[String]"
        case ._float4, ._float8: return "[Float]"
        case ._int2, ._int4, ._int8: return "[Int]"
        case ._text: return "[String]"
        case ._uuid: return "[UUID]"
        default: return "Couldn't map type"
        }
    }
    
    static let foundationArray: [SQLType] = [.uuid, ._uuid]
}
