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

@Suite("RFC_791.Version Tests")
struct VersionTests {

    // MARK: - Raw Value Initialization

    @Test
    func `Valid version values (0-15) are accepted`() {
        for value: UInt8 in 0...15 {
            let version = RFC_791.Version(rawValue: value)
            #expect(version != nil)
            #expect(version?.rawValue == value)
        }
    }

    @Test
    func `Invalid version values (>15) are rejected`() {
        for value: UInt8 in 16...255 {
            let version = RFC_791.Version(rawValue: value)
            #expect(version == nil)
        }
    }

    // MARK: - Static Constants

    @Test
    func `IPv4 version constant`() {
        #expect(RFC_791.Version.v4.rawValue == 4)
        #expect(RFC_791.Version.v4.isIPv4)
    }

    @Test
    func `IPv6 version constant`() {
        #expect(RFC_791.Version.v6.rawValue == 6)
        #expect(RFC_791.Version.v6.isIPv6)
    }

    // MARK: - Computed Properties

    @Test
    func `isIPv4 property`() {
        #expect(RFC_791.Version(rawValue: 4)?.isIPv4 == true)
        #expect(RFC_791.Version(rawValue: 6)?.isIPv4 == false)
        #expect(RFC_791.Version(rawValue: 0)?.isIPv4 == false)
    }

    @Test
    func `isIPv6 property`() {
        #expect(RFC_791.Version(rawValue: 6)?.isIPv6 == true)
        #expect(RFC_791.Version(rawValue: 4)?.isIPv6 == false)
        #expect(RFC_791.Version(rawValue: 0)?.isIPv6 == false)
    }

    // MARK: - Byte Parsing

    @Test
    func `Parse version from bytes`() throws {
        // Version is in upper 4 bits
        let bytes: [UInt8] = [0x45]  // Version 4, IHL 5
        let version = try RFC_791.Version(bytes: bytes)
        #expect(version.rawValue == 4)
    }

    @Test
    func `Parse version 6 from bytes`() throws {
        let bytes: [UInt8] = [0x60]  // Version 6
        let version = try RFC_791.Version(bytes: bytes)
        #expect(version.rawValue == 6)
    }

    @Test
    func `Parse from empty bytes throws error`() {
        let bytes: [UInt8] = []
        #expect(throws: RFC_791.Version.Error.empty) {
            try RFC_791.Version(bytes: bytes)
        }
    }

    // MARK: - Serialization

    @Test
    func `Serialize version to bytes`() {
        var buffer: [UInt8] = []
        RFC_791.Version.v4.serialize(into: &buffer)
        #expect(buffer == [0x40])  // Upper nibble only
    }

    @Test
    func `Round-trip serialization`() throws {
        let original = RFC_791.Version.v4
        var buffer: [UInt8] = []
        original.serialize(into: &buffer)

        let parsed = try RFC_791.Version(bytes: buffer)
        #expect(parsed == original)
    }

    // MARK: - CustomStringConvertible

    @Test
    func `Description format`() {
        #expect(RFC_791.Version.v4.description == "IPv4")
        #expect(RFC_791.Version.v6.description == "IPv6")
        #expect(RFC_791.Version(rawValue: 0)?.description == "Version(0)")
    }

    // MARK: - Comparable

    @Test
    func `Versions are comparable`() {
        #expect(RFC_791.Version.v4 < RFC_791.Version.v6)
        #expect(RFC_791.Version(rawValue: 0)! < RFC_791.Version.v4)
    }

    // MARK: - Equatable

    @Test
    func `Versions are equatable`() {
        #expect(RFC_791.Version.v4 == RFC_791.Version(rawValue: 4))
        #expect(RFC_791.Version.v6 == RFC_791.Version(rawValue: 6))
    }

    // MARK: - Error Tests

    @Test
    func `Error descriptions`() {
        #expect(RFC_791.Version.Error.empty.description == "Version data cannot be empty")
    }
}
