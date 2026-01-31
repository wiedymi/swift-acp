//
//  ACPSessionResponses.swift
//  ACP
//
//  Agent Client Protocol - Response Types
//

import Foundation

// MARK: - Initialize

public struct InitializeResponse: Codable, Sendable {
    public let protocolVersion: Int
    public let agentInfo: AgentInfo?
    public let agentCapabilities: AgentCapabilities
    public let authMethods: [AuthMethod]?

    enum CodingKeys: String, CodingKey {
        case protocolVersion
        case agentInfo
        case agentCapabilities
        case authMethods
    }

    public init(
        protocolVersion: Int,
        agentCapabilities: AgentCapabilities,
        agentInfo: AgentInfo? = nil,
        authMethods: [AuthMethod]? = nil
    ) {
        self.protocolVersion = protocolVersion
        self.agentCapabilities = agentCapabilities
        self.agentInfo = agentInfo
        self.authMethods = authMethods
    }
}

// MARK: - Session Management

public struct NewSessionResponse: Codable, Sendable {
    public let sessionId: SessionId
    public let modes: ModesInfo?
    public let models: ModelsInfo?
    public let configOptions: [SessionConfigOption]?

    enum CodingKeys: String, CodingKey {
        case sessionId
        case modes
        case models
        case configOptions
    }

    public init(
        sessionId: SessionId,
        modes: ModesInfo? = nil,
        models: ModelsInfo? = nil,
        configOptions: [SessionConfigOption]? = nil
    ) {
        self.sessionId = sessionId
        self.modes = modes
        self.models = models
        self.configOptions = configOptions
    }
}

public struct LoadSessionResponse: Codable, Sendable {
    public let sessionId: SessionId
    public let modes: ModesInfo?
    public let models: ModelsInfo?
    public let configOptions: [SessionConfigOption]?

    enum CodingKeys: String, CodingKey {
        case sessionId
        case modes
        case models
        case configOptions
    }

    public init(
        sessionId: SessionId,
        modes: ModesInfo? = nil,
        models: ModelsInfo? = nil,
        configOptions: [SessionConfigOption]? = nil
    ) {
        self.sessionId = sessionId
        self.modes = modes
        self.models = models
        self.configOptions = configOptions
    }
}

// MARK: - Prompt

public struct SessionPromptResponse: Codable, Sendable {
    public let stopReason: StopReason

    enum CodingKeys: String, CodingKey {
        case stopReason
    }

    public init(stopReason: StopReason) {
        self.stopReason = stopReason
    }
}

// MARK: - Mode & Model Selection

public struct SetModeResponse: Codable, Sendable {
    public let success: Bool
    public let _meta: [String: AnyCodable]?

    enum CodingKeys: String, CodingKey {
        case success
        case _meta
    }

    public init(success: Bool, _meta: [String: AnyCodable]? = nil) {
        self.success = success
        self._meta = _meta
    }
}

public struct SetModelResponse: Codable, Sendable {
    public let success: Bool
    public let _meta: [String: AnyCodable]?

    enum CodingKeys: String, CodingKey {
        case success
        case _meta
    }

    public init(success: Bool, _meta: [String: AnyCodable]? = nil) {
        self.success = success
        self._meta = _meta
    }
}

public struct SetSessionConfigOptionResponse: Codable, Sendable {
    public let configOptions: [SessionConfigOption]

    enum CodingKeys: String, CodingKey {
        case configOptions
    }

    public init(configOptions: [SessionConfigOption]) {
        self.configOptions = configOptions
    }
}

// MARK: - Authentication

public struct AuthenticateResponse: Codable, Sendable {
    public let success: Bool
    public let error: String?

    public init(success: Bool, error: String? = nil) {
        self.success = success
        self.error = error
    }
}

// MARK: - File System

public struct ReadTextFileResponse: Codable, Sendable {
    public let content: String
    public let totalLines: Int?
    public let _meta: [String: AnyCodable]?

    enum CodingKeys: String, CodingKey {
        case content
        case totalLines = "total_lines"
        case _meta
    }

    public init(content: String, totalLines: Int? = nil, _meta: [String: AnyCodable]? = nil) {
        self.content = content
        self.totalLines = totalLines
        self._meta = _meta
    }
}

public struct WriteTextFileResponse: Codable, Sendable {
    public let _meta: [String: AnyCodable]?

    enum CodingKeys: String, CodingKey {
        case _meta
    }

    public init(_meta: [String: AnyCodable]? = nil) {
        self._meta = _meta
    }
}
