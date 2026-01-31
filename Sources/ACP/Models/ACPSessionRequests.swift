//
//  ACPSessionRequests.swift
//  ACP
//
//  Agent Client Protocol - Request Types
//

import Foundation

// MARK: - Initialize

public struct InitializeRequest: Codable, Sendable {
    public let protocolVersion: Int
    public let clientCapabilities: ClientCapabilities
    public let clientInfo: ClientInfo?

    enum CodingKeys: String, CodingKey {
        case protocolVersion
        case clientCapabilities
        case clientInfo
    }

    public init(protocolVersion: Int, clientCapabilities: ClientCapabilities, clientInfo: ClientInfo? = nil) {
        self.protocolVersion = protocolVersion
        self.clientCapabilities = clientCapabilities
        self.clientInfo = clientInfo
    }
}

// MARK: - Session Management

public struct NewSessionRequest: Codable, Sendable {
    public let cwd: String
    public let mcpServers: [MCPServerConfig]

    enum CodingKeys: String, CodingKey {
        case cwd
        case mcpServers
    }

    public init(cwd: String, mcpServers: [MCPServerConfig] = []) {
        self.cwd = cwd
        self.mcpServers = mcpServers
    }
}

public struct LoadSessionRequest: Codable, Sendable {
    public let sessionId: SessionId
    public let cwd: String?
    public let mcpServers: [MCPServerConfig]?

    enum CodingKeys: String, CodingKey {
        case sessionId
        case cwd
        case mcpServers
    }

    public init(sessionId: SessionId, cwd: String? = nil, mcpServers: [MCPServerConfig]? = nil) {
        self.sessionId = sessionId
        self.cwd = cwd
        self.mcpServers = mcpServers
    }
}

public struct CancelSessionRequest: Codable, Sendable {
    public let sessionId: SessionId

    enum CodingKeys: String, CodingKey {
        case sessionId
    }

    public init(sessionId: SessionId) {
        self.sessionId = sessionId
    }
}

// MARK: - Prompt

public struct SessionPromptRequest: Codable, Sendable {
    public let sessionId: SessionId
    public let prompt: [ContentBlock]

    enum CodingKeys: String, CodingKey {
        case sessionId
        case prompt
    }

    public init(sessionId: SessionId, prompt: [ContentBlock]) {
        self.sessionId = sessionId
        self.prompt = prompt
    }
}

// MARK: - Mode & Model Selection

public struct SetModeRequest: Codable, Sendable {
    public let sessionId: SessionId
    public let modeId: String

    enum CodingKeys: String, CodingKey {
        case sessionId
        case modeId
    }

    public init(sessionId: SessionId, modeId: String) {
        self.sessionId = sessionId
        self.modeId = modeId
    }
}

public struct SetModelRequest: Codable, Sendable {
    public let sessionId: SessionId
    public let modelId: String

    enum CodingKeys: String, CodingKey {
        case sessionId
        case modelId
    }

    public init(sessionId: SessionId, modelId: String) {
        self.sessionId = sessionId
        self.modelId = modelId
    }
}

public struct SetSessionConfigOptionRequest: Codable, Sendable {
    public let sessionId: SessionId
    public let configId: SessionConfigId
    public let value: SessionConfigValueId

    enum CodingKeys: String, CodingKey {
        case sessionId
        case configId
        case value
    }

    public init(sessionId: SessionId, configId: SessionConfigId, value: SessionConfigValueId) {
        self.sessionId = sessionId
        self.configId = configId
        self.value = value
    }
}

// MARK: - Authentication

public struct AuthenticateRequest: Codable, Sendable {
    public let methodId: String
    public let credentials: [String: String]?

    enum CodingKeys: String, CodingKey {
        case methodId
        case credentials
    }

    public init(methodId: String, credentials: [String: String]? = nil) {
        self.methodId = methodId
        self.credentials = credentials
    }
}

// MARK: - File System

public struct ReadTextFileRequest: Codable, Sendable {
    public let path: String
    public let line: Int?
    public let limit: Int?
    public let sessionId: String
    public let _meta: [String: AnyCodable]?

    enum CodingKeys: String, CodingKey {
        case path, line, limit, sessionId, _meta
    }

    public init(path: String, sessionId: String, line: Int? = nil, limit: Int? = nil, _meta: [String: AnyCodable]? = nil) {
        self.path = path
        self.sessionId = sessionId
        self.line = line
        self.limit = limit
        self._meta = _meta
    }
}

public struct WriteTextFileRequest: Codable, Sendable {
    public let path: String
    public let content: String
    public let sessionId: String
    public let _meta: [String: AnyCodable]?

    enum CodingKeys: String, CodingKey {
        case path, content, sessionId, _meta
    }

    public init(path: String, content: String, sessionId: String, _meta: [String: AnyCodable]? = nil) {
        self.path = path
        self.content = content
        self.sessionId = sessionId
        self._meta = _meta
    }
}
