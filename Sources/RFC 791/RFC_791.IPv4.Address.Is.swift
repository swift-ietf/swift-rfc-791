extension RFC_791.IPv4.Address {
    public struct Is: Sendable {
        @usableFromInline
        let address: RFC_791.IPv4.Address

        @usableFromInline
        init(_ address: RFC_791.IPv4.Address) {
            self.address = address
        }
    }
}
