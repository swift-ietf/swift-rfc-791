public import RFC_791

extension RFC_791.IPv4.Address: Encodable, Decodable {

    public init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        let string = try container.decode(String.self)
        do throws(RFC_791.IPv4.Address.Error) {
            try self.init(string)
        } catch {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: error.description)
        }
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(description)
    }
}
