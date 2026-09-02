extension RFC_791.IPv4.Address {

    public enum Error: Swift.Error, Sendable, Equatable {

        case empty

        case invalidFormat(_ value: String)

        case invalidCharacter(_ value: String, code: ASCII.Code, position: Int)

        case octetOutOfRange(_ value: Int, position: Int)

        case leadingZero(_ value: String, position: Int)
    }
}

extension RFC_791.IPv4.Address.Error: CustomStringConvertible {
    public var description: String {
        switch self {
        case .empty:
            return "IPv4 address cannot be empty"

        case .invalidFormat(let value):
            return "Invalid IPv4 address format '\(value)': expected dotted-decimal"

        case .invalidCharacter(let value, let code, let position):
            let hex = String(code.underlying, radix: 16).uppercased()
            return "Invalid character 0x\(hex) in octet \(position + 1) of '\(value)'"

        case .octetOutOfRange(let value, let position):
            return "Octet \(position + 1) value \(value) is out of range (must be 0-255)"

        case .leadingZero(let value, let position):
            return "Octet \(position + 1) in '\(value)' has invalid leading zero"
        }
    }
}
