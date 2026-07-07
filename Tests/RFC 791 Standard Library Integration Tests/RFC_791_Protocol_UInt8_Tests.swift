// ===----------------------------------------------------------------------===//
//
// Copyright (c) 2025 Coen ten Thije Boonkkamp
// Licensed under Apache License v2.0
//
// See LICENSE.txt for license information
// See CONTRIBUTORS.txt for the list of project contributors
//
// SPDX-License-Identifier: Apache-2.0
//
// ===----------------------------------------------------------------------===//

import RFC_791
import RFC_791_Standard_Library_Integration
import Testing

private typealias IPProtocol = RFC_791.`Protocol`

@Suite("RFC 791 Protocol UInt8 forwarder")
struct RFC_791_Protocol_UInt8_Tests {
    @Test
    func `forwarder produces same byte as byte-domain primary`() {
        let proto = IPProtocol.tcp
        let uint8Bytes: [UInt8] = [UInt8](proto)
        #expect(uint8Bytes == [6])
    }

    @Test
    func `forwarder handles ICMP`() {
        let proto = IPProtocol.icmp
        let uint8Bytes: [UInt8] = [UInt8](proto)
        #expect(uint8Bytes == [1])
    }

    @Test
    func `forwarder handles UDP`() {
        let proto = IPProtocol.udp
        let uint8Bytes: [UInt8] = [UInt8](proto)
        #expect(uint8Bytes == [17])
    }
}
