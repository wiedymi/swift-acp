//
//  ACPCapabilities.swift
//  ACP
//
//  Agent Client Protocol - Capability Types
//

import Foundation

// MARK: - Client Capabilities

public struct ClientCapabilities: Codable, Sendable {
    public let fs: FileSystemCapabilities
    public let terminal: Bool
    public let meta: [String: AnyCodable]?

    public init(fs: FileSystemCapabilities, terminal: Bool, meta: [String: AnyCodable]? = nil) {
        self.fs = fs
        self.terminal = terminal
        self.meta = meta
    }

    enum CodingKeys: String, CodingKey {
        case fs
        case terminal
        case meta = "_meta"
    }
}

public struct FileSystemCapabilities: Codable, Sendable {
    public let readTextFile: Bool
    public let writeTextFile: Bool

    enum CodingKeys: String, CodingKey {
        case readTextFile
        case writeTextFile
    }

    public init(readTextFile: Bool, writeTextFile: Bool) {
        self.readTextFile = readTextFile
        self.writeTextFile = writeTextFile
    }
}

// MARK: - Agent Capabilities

public struct AgentCapabilities: Codable, Sendable {
    public let loadSession: Bool?
    public let mcpCapabilities: MCPCapabilities?
    public let promptCapabilities: PromptCapabilities?
    public let sessionCapabilities: SessionCapabilities?

    enum CodingKeys: String, CodingKey {
        case loadSession
        case mcpCapabilities
        case promptCapabilities
        case sessionCapabilities
    }

    public init(
        loadSession: Bool? = nil,
        mcpCapabilities: MCPCapabilities? = nil,
        promptCapabilities: PromptCapabilities? = nil,
        sessionCapabilities: SessionCapabilities? = nil
    ) {
        self.loadSession = loadSession
        self.mcpCapabilities = mcpCapabilities
        self.promptCapabilities = promptCapabilities
        self.sessionCapabilities = sessionCapabilities
    }
}

public struct MCPCapabilities: Codable, Sendable {
    public let http: Bool?
    public let sse: Bool?

    enum CodingKeys: String, CodingKey {
        case http
        case sse
    }

    public init(http: Bool? = nil, sse: Bool? = nil) {
        self.http = http
        self.sse = sse
    }
}

public struct PromptCapabilities: Codable, Sendable {
    public let audio: Bool?
    public let embeddedContext: Bool?
    public let image: Bool?

    public init(audio: Bool? = nil, embeddedContext: Bool? = nil, image: Bool? = nil) {
        self.audio = audio
        self.embeddedContext = embeddedContext
        self.image = image
    }
}

public struct SessionCapabilities: Codable, Sendable {
    public let _meta: [String: AnyCodable]?

    public init(_meta: [String: AnyCodable]? = nil) {
        self._meta = _meta
    }
}
