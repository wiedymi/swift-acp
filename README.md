# swift-acp

Swift SDK for the Agent Client Protocol (ACP).

## Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/yourusername/swift-acp", from: "1.0.0")
]
```

## Usage

```swift
import ACP

// Create client
let client = ACPClient()

// Set delegate for handling requests
await client.setDelegate(myDelegate)

// Launch agent
try await client.launch(agentPath: "/path/to/agent")

// Initialize
let initResponse = try await client.initialize(
    capabilities: ClientCapabilities(
        fs: FileSystemCapabilities(readTextFile: true, writeTextFile: true),
        terminal: true
    )
)

// Create session
let session = try await client.newSession(workingDirectory: "/path/to/workspace")

// Send prompt
let response = try await client.sendPrompt(
    sessionId: session.sessionId,
    content: [.text(TextContent(text: "Hello!"))]
)

// Listen for notifications
for await notification in client.notifications {
    // Handle session updates
}

// Cleanup
await client.terminate()
```

## Delegate Protocol

Implement `ACPClientDelegate` to handle requests from the agent:

```swift
class MyDelegate: ACPClientDelegate {
    func handleFileReadRequest(_ path: String, sessionId: String, line: Int?, limit: Int?) async throws -> ReadTextFileResponse {
        // Read file and return content
    }

    func handleFileWriteRequest(_ path: String, content: String, sessionId: String) async throws -> WriteTextFileResponse {
        // Write content to file
    }

    func handleTerminalCreate(command: String, sessionId: String, args: [String]?, cwd: String?, env: [EnvVariable]?, outputByteLimit: Int?) async throws -> CreateTerminalResponse {
        // Create terminal process
    }

    // ... other delegate methods
}
```

Default implementations are available via `ACPFileSystemDelegate` and `ACPTerminalDelegate`.

## Reference

See the `reference/` directory for the ACP specification and Rust SDK:
- `reference/agent-client-protocol/` - Protocol specification
- `reference/rust-sdk/` - Reference Rust implementation

## License

MIT
