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

@Suite("RFC_791.Identification Tests")
struct IdentificationTests {

    // MARK: - Raw Value Initialization

    @Test
    func `All 16-bit values are valid`() {
        // Test boundary values
        #expect(RFC_791.Identification(rawValue: 0).rawValue == 0)
        #expect(RFC_791.Identification(rawValue: 0xFFFF).rawValue == 65535)
        #expect(RFC_791.Identification(rawValue: 0x1234).rawValue == 0x1234)
    }

    // MARK: - Byte Parsing

    @Test
    func `Parse identification from bytes (big-endian)`() throws {
        let bytes: [UInt8] = [0x12, 0x34]
        let id = try RFC_791.Identification(bytes: bytes)
        #expect(id.rawValue == 0x1234)
    }

    @Test
    func `Parse maximum value from bytes`() throws {
        let bytes: [UInt8] = [0xFF, 0xFF]
        let id = try RFC_791.Identification(bytes: bytes)
        #expect(id.rawValue == 65535)
    }

    @Test
    func `Parse zero from bytes`() throws {
        let bytes: [UInt8] = [0x00, 0x00]
        let id = try RFC_791.Identification(bytes: bytes)
        #expect(id.rawValue == 0)
    }

    @Test
    func `Parse from empty bytes throws error`() {
        let bytes: [UInt8] = []
        #expect(throws: RFC_791.Identification.Error.empty) {
            try RFC_791.Identification(bytes: bytes)
        }
    }

    @Test
    func `Parse from insufficient bytes throws error`() {
        let bytes: [UInt8] = [0x12]
        #expect(throws: RFC_791.Identification.Error.insufficientBytes) {
            try RFC_791.Identification(bytes: bytes)
        }
    }

    // MARK: - Serialization

    @Test
    func `Serialize identification to bytes (big-endian)`() {
        var buffer: [UInt8] = []
        RFC_791.Identification(rawValue: 0x1234).serialize(into: &buffer)
        #expect(buffer == [0x12, 0x34])
    }

    @Test
    func `Serialize maximum value`() {
        var buffer: [UInt8] = []
        RFC_791.Identification(rawValue: 0xFFFF).serialize(into: &buffer)
        #expect(buffer == [0xFF, 0xFF])
    }

    @Test
    func `Round-trip serialization`() throws {
        let original = RFC_791.Identification(rawValue: 0xABCD)
        var buffer: [UInt8] = []
        original.serialize(into: &buffer)

        let parsed = try RFC_791.Identification(bytes: buffer)
        #expect(parsed == original)
    }

    // MARK: - CustomStringConvertible

    @Test
    func `Description format (hexadecimal)`() {
        #expect(RFC_791.Identification(rawValue: 0x1234).description == "0x1234")
        #expect(RFC_791.Identification(rawValue: 0x0001).description == "0x1")
        #expect(RFC_791.Identification(rawValue: 0xFFFF).description == "0xFFFF")
    }

    // MARK: - Comparable

    @Test
    func `Identifications are comparable`() {
        let low = RFC_791.Identification(rawValue: 100)
        let high = RFC_791.Identification(rawValue: 200)
        #expect(low < high)
    }

    // MARK: - ExpressibleByIntegerLiteral

    @Test
    func `Integer literal initialization`() {
        let id: RFC_791.Identification = 0x5678
        #expect(id.rawValue == 0x5678)
    }

    // MARK: - Error Tests

    @Test
    func `Error descriptions`() {
        let emptyDesc = RFC_791.Identification.Error.empty.description
        #expect(emptyDesc == "Identification data cannot be empty")
        let insufficientDesc = RFC_791.Identification.Error.insufficientBytes.description
        #expect(insufficientDesc == "Identification requires 2 bytes")
    }
}
