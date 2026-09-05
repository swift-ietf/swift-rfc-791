extension RFC_791 {

    public struct TypeOfService: RawRepresentable, Hashable, Sendable {

        public let rawValue: UInt8

        init(__unchecked: Void, rawValue: UInt8) {
            self.rawValue = rawValue
        }

        public init?(rawValue: UInt8) {

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
            var value: UInt8 = precedence.rawValue << 5
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
