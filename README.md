# RFC 791

![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)
[![CI](https://github.com/swift-ietf/swift-rfc-791/workflows/CI/badge.svg)](https://github.com/swift-ietf/swift-rfc-791/actions/workflows/ci.yml)

Swift implementation of RFC 791: Internet Protocol (IPv4).

## Overview

This package is the pure domain model of the IPv4 header defined in RFC 791 (September 1981): every header field is a distinct type carrying its invariants, derived quantities and well-known values, and the IPv4 address carries its class and its dotted-decimal text form. It has no parser, serializer or formatter dependencies.

The wire forms live in the sibling package [swift-rfc-791-coder](https://github.com/swift-ietf/swift-rfc-791-coder): `<Type>.Coder` over a byte cursor for every field, `Binary.Serializable` conformances, and the address's `ASCII.Parseable`/`ASCII.Serializable` text form and `Binary.Parseable`.

## Products

- `RFC 791` — the domain model.
- `RFC 791 Standard Library Integration` — `RFC_791.IPv4.Address(_:_:_:_:)` from four `UInt8` octets.
- `RFC 791 Foundation Integration` — `Codable` for every type (addresses code as dotted-decimal text, fields as their raw numbers).

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/swift-ietf/swift-rfc-791.git", branch: "main")
]
```

```swift
.target(
    name: "YourTarget",
    dependencies: [
        .product(name: "RFC 791", package: "swift-rfc-791")
    ]
)
```

## Quick Start

```swift
import RFC_791

let address = try RFC_791.IPv4.Address("192.168.1.1")
address.octets        // (192, 168, 1, 1)
address.class         // .c
address.description   // "192.168.1.1"

let ttl = RFC_791.TTL.default64
let proto = RFC_791.`Protocol`.tcp
let flags = RFC_791.Flags(dontFragment: true, moreFragments: false)
```

## Usage

### IPv4 addresses

```swift
let fromText = try RFC_791.IPv4.Address("10.0.0.1")
let fromRawValue = RFC_791.IPv4.Address(rawValue: 0xC0A8_0001)
let fromOctets = RFC_791.IPv4.Address(Byte(bitPattern: 127), Byte(bitPattern: 0), Byte(bitPattern: 0), Byte(bitPattern: 1))

fromText.class          // .a
fromText.is.multicast   // false
fromText.is.reserved    // false

RFC_791.IPv4.Address.any        // 0.0.0.0
RFC_791.IPv4.Address.broadcast  // 255.255.255.255
RFC_791.IPv4.Address.loopback   // 127.0.0.1
```

### IP header fields

```swift
RFC_791.Version.v4.isIPv4                    // true

let ihl = RFC_791.IHL.minimum
ihl.byteLength                               // 20
ihl.hasOptions                               // false

let ttl = RFC_791.TTL(rawValue: 64)
ttl.isExpired                                // false
ttl.decremented?.rawValue                    // 63

RFC_791.`Protocol`.icmp.rawValue             // 1
RFC_791.`Protocol`.tcp.rawValue              // 6
RFC_791.`Protocol`.udp.rawValue              // 17

RFC_791.Identification(rawValue: 0x1234)
RFC_791.TotalLength(rawValue: 1500)?.maximumDataLength  // 1480
```

### Type of Service

```swift
let tos = RFC_791.TypeOfService(
    precedence: .immediate,
    lowDelay: true,
    highThroughput: false,
    highReliability: true
)

tos.precedence          // .immediate
tos.lowDelay            // true

RFC_791.Precedence.routine.rawValue          // 0
RFC_791.Precedence.networkControl.rawValue   // 7
```

### Fragmentation

```swift
let flags = RFC_791.Flags(dontFragment: false, moreFragments: true)
flags.moreFragments     // true

let offset = RFC_791.FragmentOffset(rawValue: 185)!
offset.byteOffset       // 1480
offset.isFirstFragment  // false

RFC_791.FragmentOffset.fromByteOffset(0)!.isFirstFragment  // true
```

### Header checksum

```swift
let header: [Byte] = [
    0x45, 0x00, 0x00, 0x73, 0x00, 0x00, 0x40, 0x00,
    0x40, 0x11, 0x00, 0x00,
    0xC0, 0xA8, 0x00, 0x01, 0xC0, 0xA8, 0x00, 0xC7,
].map(Byte.init(bitPattern:))

RFC_791.HeaderChecksum.compute(over: header).rawValue  // 0xB861

let complete: [Byte] = [
    0x45, 0x00, 0x00, 0x73, 0x00, 0x00, 0x40, 0x00,
    0x40, 0x11, 0xB8, 0x61,
    0xC0, 0xA8, 0x00, 0x01, 0xC0, 0xA8, 0x00, 0xC7,
].map(Byte.init(bitPattern:))

RFC_791.HeaderChecksum.verify(header: complete)  // true
```

## Header format

```
 0                   1                   2                   3
 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1 2 3 4 5 6 7 8 9 0 1
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|Version|  IHL  |Type of Service|          Total Length         |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|         Identification        |Flags|      Fragment Offset    |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|  Time to Live |    Protocol   |         Header Checksum       |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                       Source Address                          |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
|                    Destination Address                        |
+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+
```

| Field | Bits | Type |
|-------|------|------|
| Version | 4 | `RFC_791.Version` |
| IHL | 4 | `RFC_791.IHL` |
| Type of Service | 8 | `RFC_791.TypeOfService` |
| Total Length | 16 | `RFC_791.TotalLength` |
| Identification | 16 | `RFC_791.Identification` |
| Flags | 3 | `RFC_791.Flags` |
| Fragment Offset | 13 | `RFC_791.FragmentOffset` |
| Time to Live | 8 | `RFC_791.TTL` |
| Protocol | 8 | `RFC_791.Protocol` |
| Header Checksum | 16 | `RFC_791.HeaderChecksum` |
| Source Address | 32 | `RFC_791.IPv4.Address` |
| Destination Address | 32 | `RFC_791.IPv4.Address` |

## License

This package is licensed under the Apache License 2.0. See [LICENSE.md](LICENSE.md) for details.
