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

@Suite("RFC_791.TTL Tests")
struct TTLTests {

    // MARK: - Raw Value Initialization

    @Test
    func `All 8-bit values are valid TTL values`() {
        for value: UInt8 in 0...255 {
            let ttl = RFC_791.TTL(rawValue: value)
            #expect(ttl.rawValue == value)
        }
    }

    // MARK: - Static Constants

    @Test
    func `Default64 constant (Linux/macOS)`() {
        #expect(RFC_791.TTL.default64.rawValue == 64)
    }

    @Test
    func `Default128 constant (Windows)`() {
        #expect(RFC_791.TTL.default128.rawValue == 128)
    }

    @Test
    func `Maximum constant`() {
        #expect(RFC_791.TTL.maximum.rawValue == 255)
    }

    @Test
    func `Expired constant`() {
        #expect(RFC_791.TTL.expired.rawValue == 0)
        #expect(RFC_791.TTL.expired.isExpired)
    }

    @Test
    func `LinkLocal constant`() {
        #expect(RFC_791.TTL.linkLocal.rawValue == 1)
    }

    // MARK: - Computed Properties

    @Test
    func `isExpired property`() {
        #expect(RFC_791.TTL(rawValue: 0).isExpired == true)
        #expect(RFC_791.TTL(rawValue: 1).isExpired == false)
        #expect(RFC_791.TTL(rawValue: 255).isExpired == false)
    }

    @Test
    func `decremented property`() {
        #expect(RFC_791.TTL(rawValue: 64).decremented?.rawValue == 63)
        #expect(RFC_791.TTL(rawValue: 1).decremented?.rawValue == 0)
        #expect(RFC_791.TTL(rawValue: 0).decremented == nil)
    }

    @Test
    func `Decrement chain simulation`() {
        var ttl: RFC_791.TTL? = RFC_791.TTL(rawValue: 5)
        var hops = 0

        while let current = ttl {
            ttl = current.decremented
            hops += 1
        }

        // Starting at 5, we decrement through 4, 3, 2, 1, 0, then nil
        // That's 6 iterations (including the 0 state)
        #expect(hops == 6)
    }

    // MARK: - Byte Parsing

    @Test
    func `Parse TTL from bytes`() throws {
        let bytes: [UInt8] = [64]
        let ttl = try RFC_791.TTL(bytes: bytes)
        #expect(ttl.rawValue == 64)
    }

    @Test
    func `Parse from empty bytes throws error`() {
        let bytes: [UInt8] = []
        #expect(throws: RFC_791.TTL.Error.empty) {
            try RFC_791.TTL(bytes: bytes)
        }
    }

    // MARK: - Serialization

    @Test
    func `Serialize TTL to bytes`() {
        var buffer: [UInt8] = []
        RFC_791.TTL.default64.serialize(into: &buffer)
        #expect(buffer == [64])
    }

    @Test
    func `Round-trip serialization`() throws {
        let original = RFC_791.TTL(rawValue: 128)
        var buffer: [UInt8] = []
        original.serialize(into: &buffer)

        let parsed = try RFC_791.TTL(bytes: buffer)
        #expect(parsed == original)
    }

    // MARK: - CustomStringConvertible

    @Test
    func `Description format`() {
        #expect(RFC_791.TTL(rawValue: 64).description == "TTL(64)")
        #expect(RFC_791.TTL(rawValue: 0).description == "TTL(0)")
    }

    // MARK: - Comparable

    @Test
    func `TTL values are comparable`() {
        #expect(RFC_791.TTL.expired < RFC_791.TTL.default64)
        #expect(RFC_791.TTL.default64 < RFC_791.TTL.maximum)
    }

    // MARK: - ExpressibleByIntegerLiteral

    @Test
    func `Integer literal initialization`() {
        let ttl: RFC_791.TTL = 64
        #expect(ttl.rawValue == 64)
    }

    // MARK: - Error Tests

    @Test
    func `Error descriptions`() {
        #expect(RFC_791.TTL.Error.empty.description == "TTL data cannot be empty")
    }
}
