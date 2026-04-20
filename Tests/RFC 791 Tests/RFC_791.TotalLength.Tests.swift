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

import Testing

@testable import RFC_791

@Suite("RFC_791.TotalLength Tests")
struct TotalLengthTests {

    // MARK: - Raw Value Initialization

    @Test
    func `Valid total length values (20-65535) are accepted`() {
        #expect(RFC_791.TotalLength(rawValue: 20)?.rawValue == 20)
        #expect(RFC_791.TotalLength(rawValue: 576)?.rawValue == 576)
        #expect(RFC_791.TotalLength(rawValue: 1500)?.rawValue == 1500)
        #expect(RFC_791.TotalLength(rawValue: 65535)?.rawValue == 65535)
    }

    @Test
    func `Invalid total length values (<20) are rejected`() {
        for value: UInt16 in 0..<20 {
            let length = RFC_791.TotalLength(rawValue: value)
            #expect(length == nil)
        }
    }

    // MARK: - Static Constants

    @Test
    func `Minimum constant`() {
        #expect(RFC_791.TotalLength.minimum.rawValue == 20)
        #expect(RFC_791.TotalLength.minimum.isMinimum)
    }

    @Test
    func `Maximum constant`() {
        #expect(RFC_791.TotalLength.maximum.rawValue == 65535)
    }

    @Test
    func `Minimum reassembly buffer constant`() {
        #expect(RFC_791.TotalLength.minimumReassemblyBuffer.rawValue == 576)
    }

    @Test
    func `Ethernet MTU constant`() {
        #expect(RFC_791.TotalLength.ethernetMTU.rawValue == 1500)
    }

    // MARK: - Computed Properties

    @Test
    func `maximumDataLength calculation`() {
        #expect(RFC_791.TotalLength(rawValue: 20)?.maximumDataLength == 0)
        #expect(RFC_791.TotalLength(rawValue: 1500)?.maximumDataLength == 1480)
        #expect(RFC_791.TotalLength(rawValue: 65535)?.maximumDataLength == 65515)
    }

    @Test
    func `isMinimum property`() {
        #expect(RFC_791.TotalLength(rawValue: 20)?.isMinimum == true)
        #expect(RFC_791.TotalLength(rawValue: 21)?.isMinimum == false)
        #expect(RFC_791.TotalLength(rawValue: 1500)?.isMinimum == false)
    }

    // MARK: - Byte Parsing

    @Test
    func `Parse total length from bytes (big-endian)`() throws {
        let bytes: [UInt8] = [0x05, 0xDC]  // 1500
        let length = try RFC_791.TotalLength(bytes: bytes)
        #expect(length.rawValue == 1500)
    }

    @Test
    func `Parse minimum from bytes`() throws {
        let bytes: [UInt8] = [0x00, 0x14]  // 20
        let length = try RFC_791.TotalLength(bytes: bytes)
        #expect(length.rawValue == 20)
    }

    @Test
    func `Parse from empty bytes throws error`() {
        let bytes: [UInt8] = []
        #expect(throws: RFC_791.TotalLength.Error.empty) {
            try RFC_791.TotalLength(bytes: bytes)
        }
    }

    @Test
    func `Parse from insufficient bytes throws error`() {
        let bytes: [UInt8] = [0x05]
        #expect(throws: RFC_791.TotalLength.Error.insufficientBytes) {
            try RFC_791.TotalLength(bytes: bytes)
        }
    }

    @Test
    func `Parse too small value throws error`() {
        let bytes: [UInt8] = [0x00, 0x10]  // 16 (less than minimum 20)
        #expect(throws: RFC_791.TotalLength.Error.tooSmall(16)) {
            try RFC_791.TotalLength(bytes: bytes)
        }
    }

    // MARK: - Serialization

    @Test
    func `Serialize total length to bytes (big-endian)`() {
        var buffer: [UInt8] = []
        RFC_791.TotalLength(rawValue: 1500)!.serialize(into: &buffer)
        #expect(buffer == [0x05, 0xDC])
    }

    @Test
    func `Round-trip serialization`() throws {
        let original = RFC_791.TotalLength(rawValue: 576)!
        var buffer: [UInt8] = []
        original.serialize(into: &buffer)

        let parsed = try RFC_791.TotalLength(bytes: buffer)
        #expect(parsed == original)
    }

    // MARK: - CustomStringConvertible

    @Test
    func `Description format`() {
        #expect(RFC_791.TotalLength(rawValue: 1500)?.description == "1500 bytes")
        #expect(RFC_791.TotalLength(rawValue: 20)?.description == "20 bytes")
    }

    // MARK: - Comparable

    @Test
    func `Total lengths are comparable`() {
        #expect(RFC_791.TotalLength.minimum < RFC_791.TotalLength.ethernetMTU)
        #expect(RFC_791.TotalLength.ethernetMTU < RFC_791.TotalLength.maximum)
    }

    // MARK: - Error Tests

    @Test
    func `Error descriptions`() {
        let emptyDesc = RFC_791.TotalLength.Error.empty.description
        #expect(emptyDesc == "TotalLength data cannot be empty")
        let insufficientDesc = RFC_791.TotalLength.Error.insufficientBytes.description
        #expect(insufficientDesc == "TotalLength requires 2 bytes")
        let tooSmallDesc = RFC_791.TotalLength.Error.tooSmall(10).description
        #expect(tooSmallDesc == "TotalLength 10 is less than minimum header size of 20")
    }
}
