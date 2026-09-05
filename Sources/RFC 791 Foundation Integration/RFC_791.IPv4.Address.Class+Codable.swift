public import RFC_791

extension RFC_791.IPv4.Address.Class: Encodable, Decodable {

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let letter = try container.decode(String.self)
        switch letter {
        case "A": self = .a
        case "B": self = .b
        case "C": self = .c
        case "D": self = .d
        case "E": self = .e
        default:
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Unknown IPv4 address class '\(letter)'"
            )
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        switch self {
        case .a: try container.encode("A")
        case .b: try container.encode("B")
        case .c: try container.encode("C")
        case .d: try container.encode("D")
        case .e: try container.encode("E")
        }
    }
}
