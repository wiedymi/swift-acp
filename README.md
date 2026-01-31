# swift-acp

[![GitHub](https://img.shields.io/badge/-GitHub-181717?style=flat-square&logo=github&logoColor=white)](https://github.com/wiedymi)
[![Twitter](https://img.shields.io/badge/-Twitter-1DA1F2?style=flat-square&logo=twitter&logoColor=white)](https://x.com/wiedymi)
[![Email](https://img.shields.io/badge/-Email-EA4335?style=flat-square&logo=gmail&logoColor=white)](mailto:contact@wiedymi.com)
[![Discord](https://img.shields.io/badge/-Discord-5865F2?style=flat-square&logo=discord&logoColor=white)](https://discord.gg/zemMZtrkSb)
[![Support me](https://img.shields.io/badge/-Support%20me-ff69b4?style=flat-square&logo=githubsponsors&logoColor=white)](https://github.com/sponsors/vivy-company)

Swift SDK for the [Agent Client Protocol (ACP)](https://agentclientprotocol.com/).

## Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/wiedymi/swift-acp", from: "1.0.0")
]
```

Then add the dependency to your target:

```swift
.target(
    name: "YourApp",
    dependencies: ["ACP"]
)
```

## Usage

```swift
import ACP

// Create client
let client = ACPClient()

// Set delegate for handling agent requests
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
        let content = try String(contentsOfFile: path, encoding: .utf8)
        return ReadTextFileResponse(content: content)
    }

    func handleFileWriteRequest(_ path: String, content: String, sessionId: String) async throws -> WriteTextFileResponse {
        try content.write(toFile: path, atomically: true, encoding: .utf8)
        return WriteTextFileResponse()
    }

    func handleTerminalCreate(command: String, sessionId: String, args: [String]?, cwd: String?, env: [EnvVariable]?, outputByteLimit: Int?) async throws -> CreateTerminalResponse {
        // Create terminal process and return terminal ID
    }

    func handleTerminalOutput(terminalId: TerminalId, sessionId: String) async throws -> TerminalOutputResponse {
        // Return terminal output
    }

    func handleTerminalWaitForExit(terminalId: TerminalId, sessionId: String) async throws -> WaitForExitResponse {
        // Wait for terminal to exit
    }

    func handleTerminalKill(terminalId: TerminalId, sessionId: String) async throws -> KillTerminalResponse {
        // Kill terminal process
    }

    func handleTerminalRelease(terminalId: TerminalId, sessionId: String) async throws -> ReleaseTerminalResponse {
        // Release terminal resources
    }

    func handlePermissionRequest(request: RequestPermissionRequest) async throws -> RequestPermissionResponse {
        // Handle permission request from agent
    }
}
```

Default implementations are available via `ACPFileSystemDelegate` and `ACPTerminalDelegate`.

## Debug Mode

Enable debug streaming to inspect raw JSON-RPC messages:

```swift
await client.enableDebugStream()

if let debugStream = await client.debugMessages {
    for await message in debugStream {
        print("\(message.direction): \(message.jsonString ?? "")")
    }
}
```

## Requirements

- macOS 13.0+
- Swift 5.9+

## License

MIT
