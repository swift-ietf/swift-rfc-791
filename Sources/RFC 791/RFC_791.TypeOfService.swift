extension RFC_791 {

    public struct TypeOfService: Hashable, Sendable, Codable {

        public let rawValue: Byte

        init(__unchecked: Void, rawValue: Byte) {
            self.rawValue = rawValue
        }

        public init?(rawValue: Byte) {

            guard rawValue & 0b0000_0011 == 0 else {
                return nil
            }
            self.init(__unchecked: (), rawValue: rawValue)
        }

        public init(
            precedence: Precedence = .routine,
            lowDelay: Bool = false,
            highThroughput: Bool = false,
            highReliability: Bool = false
        ) {
            var value: Byte = precedence.rawValue << 5
            if lowDelay { value |= 0b0001_0000 }
            if highThroughput { value |= 0b0000_1000 }
            if highReliability { value |= 0b0000_0100 }
            self.init(__unchecked: (), rawValue: value)
        }
    }
}

extension RFC_791.TypeOfService {

    public var precedence: RFC_791.Precedence {
        RFC_791.Precedence(__unchecked: (), rawValue: rawValue >> 5)
    }

    public var lowDelay: Bool {
        (rawValue & 0b0001_0000) != 0
    }

    public var highThroughput: Bool {
        (rawValue & 0b0000_1000) != 0
    }

    public var highReliability: Bool {
        (rawValue & 0b0000_0100) != 0
    }
}

extension RFC_791.TypeOfService {

    public static let `default` = RFC_791.TypeOfService(__unchecked: (), rawValue: 0)

    public static let minimizeDelay = RFC_791.TypeOfService(lowDelay: true)

    public static let maximizeThroughput = RFC_791.TypeOfService(highThroughput: true)

    public static let maximizeReliability = RFC_791.TypeOfService(highReliability: true)
}

extension RFC_791.TypeOfService {

    public init<Bytes: Swift.Collection>(bytes: Bytes) throws(Error)
    where Bytes.Element == Byte {
        guard let firstByte = bytes.first else {
            throw .empty
        }

        guard firstByte & 0b0000_0011 == 0 else {
            throw .reservedBitsSet(firstByte)
        }

        self.init(__unchecked: (), rawValue: firstByte)
    }
}

extension RFC_791.TypeOfService: Binary.Serializable {
    public static func serialize<Buffer: RangeReplaceableCollection>(
        _ tos: Self,
        into buffer: inout Buffer
    ) where Buffer.Element == Byte {
        buffer.append(tos.rawValue)
    }
}

extension [Byte] {

    public init(_ tos: RFC_791.TypeOfService) {
        self = [tos.rawValue]
    }
}

extension RFC_791.TypeOfService: CustomStringConvertible {
    public var description: String {
        var flags: [String] = []
        if lowDelay { flags.append("LowDelay") }
        if highThroughput { flags.append("HighThroughput") }
        if highReliability { flags.append("HighReliability") }

        let flagsString = flags.isEmpty ? "None" : flags.joined(separator: ", ")
        return "TypeOfService(precedence: \(precedence), flags: [\(flagsString)])"
    }
}
