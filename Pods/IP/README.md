# IP for Swift

<img src="./.github/host.png" width="33%">
<img src="./.github/routing-table.png" width="33%">
<img src="./.github/interface.png" width="33%">

## Usage

### Get Host name and IP

```swift
let host = try! Host.current()
```

### Get routing table

```swift
let messages = try! System.routingTable()
```

#### Optional flags

```swift
let messages = try! System.routingTable(.availableNetwork)
```

### Get network interfaces

```swift
let interfaces = try! Interface.all()
```

### Get default gateway IP

```swift
let interface = interfaces[indexPath.row]
let message = try! System.retrieveDefaultGatewayMessage(from: interface)!
print(message.gateway!)
// Prints "IP(version: IPv4, address: "192.168.1.253", port: 0)"
```

## Installation

### CocoaPods

```bash
pod ""
```
