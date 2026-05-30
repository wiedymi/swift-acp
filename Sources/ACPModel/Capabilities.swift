//
//  Capabilities.swift
//  ACPModel
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
    public let _meta: [String: AnyCodable]?

    enum CodingKeys: String, CodingKey {
        case readTextFile
        case writeTextFile
        case _meta
    }

    public init(readTextFile: Bool, writeTextFile: Bool, _meta: [String: AnyCodable]? = nil) {
        self.readTextFile = readTextFile
        self.writeTextFile = writeTextFile
        self._meta = _meta
    }
}

// MARK: - Agent Capabilities

public struct AgentCapabilities: Codable, Sendable {
    public let _meta: [String: AnyCodable]?
    public let auth: AgentAuthCapabilities?
    public let loadSession: Bool?
    public let mcpCapabilities: MCPCapabilities?
    public let promptCapabilities: PromptCapabilities?
    public let sessionCapabilities: SessionCapabilities?

    enum CodingKeys: String, CodingKey {
        case _meta
        case auth
        case loadSession
        case mcpCapabilities
        case promptCapabilities
        case sessionCapabilities
    }

    public init(
        _meta: [String: AnyCodable]? = nil,
        auth: AgentAuthCapabilities? = nil,
        loadSession: Bool? = nil,
        mcpCapabilities: MCPCapabilities? = nil,
        promptCapabilities: PromptCapabilities? = nil,
        sessionCapabilities: SessionCapabilities? = nil
    ) {
        self._meta = _meta
        self.auth = auth
        self.loadSession = loadSession
        self.mcpCapabilities = mcpCapabilities
        self.promptCapabilities = promptCapabilities
        self.sessionCapabilities = sessionCapabilities
    }
}

/// Authentication-related capabilities advertised by the agent.
public struct AgentAuthCapabilities: Codable, Sendable {
    /// Present (even as an empty object) when the agent supports the `logout` method.
    public let logout: LogoutCapabilities?
    public let _meta: [String: AnyCodable]?

    enum CodingKeys: String, CodingKey {
        case logout
        case _meta
    }

    public init(logout: LogoutCapabilities? = nil, _meta: [String: AnyCodable]? = nil) {
        self.logout = logout
        self._meta = _meta
    }
}

/// Logout capabilities supported by the agent.
///
/// Supplying `{}` means the agent supports the `logout` method.
public struct LogoutCapabilities: Codable, Sendable {
    public let _meta: [String: AnyCodable]?

    public init(_meta: [String: AnyCodable]? = nil) {
        self._meta = _meta
    }
}

public struct MCPCapabilities: Codable, Sendable {
    public let http: Bool?
    public let sse: Bool?
    public let _meta: [String: AnyCodable]?

    enum CodingKeys: String, CodingKey {
        case http
        case sse
        case _meta
    }

    public init(http: Bool? = nil, sse: Bool? = nil, _meta: [String: AnyCodable]? = nil) {
        self.http = http
        self.sse = sse
        self._meta = _meta
    }
}

public struct PromptCapabilities: Codable, Sendable {
    public let audio: Bool?
    public let embeddedContext: Bool?
    public let image: Bool?
    public let _meta: [String: AnyCodable]?

    enum CodingKeys: String, CodingKey {
        case audio
        case embeddedContext
        case image
        case _meta
    }

    public init(audio: Bool? = nil, embeddedContext: Bool? = nil, image: Bool? = nil, _meta: [String: AnyCodable]? = nil) {
        self.audio = audio
        self.embeddedContext = embeddedContext
        self.image = image
        self._meta = _meta
    }
}

public struct SessionCapabilities: Codable, Sendable {
    public let _meta: [String: AnyCodable]?
    public let close: SessionCloseCapabilities?
    public let fork: SessionForkCapabilities?
    public let list: SessionListCapabilities?
    public let resume: SessionResumeCapabilities?

    public init(
        _meta: [String: AnyCodable]? = nil,
        close: SessionCloseCapabilities? = nil,
        fork: SessionForkCapabilities? = nil,
        list: SessionListCapabilities? = nil,
        resume: SessionResumeCapabilities? = nil
    ) {
        self._meta = _meta
        self.close = close
        self.fork = fork
        self.list = list
        self.resume = resume
    }
}

public struct SessionCloseCapabilities: Codable, Sendable {
    public let _meta: [String: AnyCodable]?

    public init(_meta: [String: AnyCodable]? = nil) {
        self._meta = _meta
    }
}

public struct SessionForkCapabilities: Codable, Sendable {
    public let _meta: [String: AnyCodable]?

    public init(_meta: [String: AnyCodable]? = nil) {
        self._meta = _meta
    }
}

public struct SessionListCapabilities: Codable, Sendable {
    public let _meta: [String: AnyCodable]?

    public init(_meta: [String: AnyCodable]? = nil) {
        self._meta = _meta
    }
}

public struct SessionResumeCapabilities: Codable, Sendable {
    public let _meta: [String: AnyCodable]?

    public init(_meta: [String: AnyCodable]? = nil) {
        self._meta = _meta
    }
}
