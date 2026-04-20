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

@Suite("RFC_791.FragmentOffset Tests")
struct FragmentOffsetTests {

    // MARK: - Raw Value Initialization

    @Test
    func `Valid fragment offset values (0-8191) are accepted`() {
        #expect(RFC_791.FragmentOffset(rawValue: 0)?.rawValue == 0)
        #expect(RFC_791.FragmentOffset(rawValue: 185)?.rawValue == 185)  // 1480 bytes
        #expect(RFC_791.FragmentOffset(rawValue: 0x1FFF)?.rawValue == 8191)
    }

    @Test
    func `Invalid fragment offset values (>8191) are rejected`() {
        #expect(RFC_791.FragmentOffset(rawValue: 0x2000) == nil)
        #expect(RFC_791.FragmentOffset(rawValue: 0xFFFF) == nil)
    }

    // MARK: - Static Constants

    @Test
    func `Zero offset constant`() {
        #expect(RFC_791.FragmentOffset.zero.rawValue == 0)
        #expect(RFC_791.FragmentOffset.zero.byteOffset == 0)
        #expect(RFC_791.FragmentOffset.zero.isFirstFragment)
    }

    @Test
    func `Maximum offset constant`() {
        #expect(RFC_791.FragmentOffset.maximum.rawValue == 8191)
        #expect(RFC_791.FragmentOffset.maximum.byteOffset == 65528)
    }

    // MARK: - Computed Properties

    @Test
    func `byteOffset calculation`() {
        #expect(RFC_791.FragmentOffset(rawValue: 0)?.byteOffset == 0)
        #expect(RFC_791.FragmentOffset(rawValue: 1)?.byteOffset == 8)
        #expect(RFC_791.FragmentOffset(rawValue: 185)?.byteOffset == 1480)  // Typical MTU boundary
        #expect(RFC_791.FragmentOffset(rawValue: 8191)?.byteOffset == 65528)
    }

    @Test
    func `isFirstFragment property`() {
        #expect(RFC_791.FragmentOffset(rawValue: 0)?.isFirstFragment == true)
        #expect(RFC_791.FragmentOffset(rawValue: 1)?.isFirstFragment == false)
        #expect(RFC_791.FragmentOffset(rawValue: 185)?.isFirstFragment == false)
    }

    // MARK: - Factory Methods

    @Test
    func `Create from byte offset`() {
        #expect(RFC_791.FragmentOffset.fromByteOffset(0)?.rawValue == 0)
        #expect(RFC_791.FragmentOffset.fromByteOffset(8)?.rawValue == 1)
        #expect(RFC_791.FragmentOffset.fromByteOffset(1480)?.rawValue == 185)
        #expect(RFC_791.FragmentOffset.fromByteOffset(65528)?.rawValue == 8191)
    }

    @Test
    func `Create from invalid byte offset`() {
        #expect(RFC_791.FragmentOffset.fromByteOffset(-1) == nil)  // Negative
        #expect(RFC_791.FragmentOffset.fromByteOffset(7) == nil)  // Not divisible by 8
        #expect(RFC_791.FragmentOffset.fromByteOffset(65536) == nil)  // Too large
    }

    // MARK: - Byte Parsing

    @Test
    func `Parse fragment offset from bytes`() throws {
        // Fragment offset is in lower 13 bits
        let bytes: [UInt8] = [0x00, 0xB9]  // Offset 185
        let offset = try RFC_791.FragmentOffset(bytes: bytes)
        #expect(offset.rawValue == 185)
    }

    @Test
    func `Parse with flags in upper bits`() throws {
        // Flags DF=1, MF=0 in upper 3 bits, offset 185
        let bytes: [UInt8] = [0x40, 0xB9]  // DF set, offset 185
        let offset = try RFC_791.FragmentOffset(bytes: bytes)
        #expect(offset.rawValue == 185)  // Flags should be masked out
    }

    @Test
    func `Parse maximum offset from bytes`() throws {
        let bytes: [UInt8] = [0x1F, 0xFF]  // Maximum 13-bit value
        let offset = try RFC_791.FragmentOffset(bytes: bytes)
        #expect(offset.rawValue == 8191)
    }

    @Test
    func `Parse from empty bytes throws error`() {
        let bytes: [UInt8] = []
        #expect(throws: RFC_791.FragmentOffset.Error.empty) {
            try RFC_791.FragmentOffset(bytes: bytes)
        }
    }

    @Test
    func `Parse from insufficient bytes throws error`() {
        let bytes: [UInt8] = [0x00]
        #expect(throws: RFC_791.FragmentOffset.Error.insufficientBytes) {
            try RFC_791.FragmentOffset(bytes: bytes)
        }
    }

    // MARK: - Serialization

    @Test
    func `Serialize fragment offset to bytes`() {
        var buffer: [UInt8] = []
        RFC_791.FragmentOffset(rawValue: 185)!.serialize(into: &buffer)
        #expect(buffer == [0x00, 0xB9])
    }

    @Test
    func `Serialize maximum offset`() {
        var buffer: [UInt8] = []
        RFC_791.FragmentOffset.maximum.serialize(into: &buffer)
        #expect(buffer == [0x1F, 0xFF])
    }

    @Test
    func `Round-trip serialization`() throws {
        let original = RFC_791.FragmentOffset(rawValue: 370)!  // 2960 bytes
        var buffer: [UInt8] = []
        original.serialize(into: &buffer)

        let parsed = try RFC_791.FragmentOffset(bytes: buffer)
        #expect(parsed == original)
    }

    // MARK: - CustomStringConvertible

    @Test
    func `Description format`() {
        let zeroDesc = RFC_791.FragmentOffset(rawValue: 0)?.description
        #expect(zeroDesc == "FragmentOffset(0 = 0 bytes)")
        let offset185Desc = RFC_791.FragmentOffset(rawValue: 185)?.description
        #expect(offset185Desc == "FragmentOffset(185 = 1480 bytes)")
    }

    // MARK: - Comparable

    @Test
    func `Fragment offsets are comparable`() {
        #expect(RFC_791.FragmentOffset.zero < RFC_791.FragmentOffset.maximum)
        #expect(RFC_791.FragmentOffset(rawValue: 100)! < RFC_791.FragmentOffset(rawValue: 200)!)
    }

    // MARK: - Error Tests

    @Test
    func `Error descriptions`() {
        let emptyDesc = RFC_791.FragmentOffset.Error.empty.description
        #expect(emptyDesc == "FragmentOffset data cannot be empty")
        let insufficientDesc = RFC_791.FragmentOffset.Error.insufficientBytes.description
        #expect(insufficientDesc == "FragmentOffset requires 2 bytes")
    }
}
