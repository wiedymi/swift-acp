//
//  Config.swift
//  ACPModel
//
//  Agent Client Protocol - Config Options Types
//

import Foundation

// MARK: - Session Config Option

public struct SessionConfigOption: Codable, Sendable {
    public let id: SessionConfigId
    public let name: String
    public let description: String?
    public let kind: SessionConfigKind

    enum CodingKeys: String, CodingKey {
        case id
        case name
        case description
        case kind
        case type
        case currentValue
        case options
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(SessionConfigId.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decodeIfPresent(String.self, forKey: .description)

        if container.contains(.kind) {
            let nested = try container.superDecoder(forKey: .kind)
            kind = try SessionConfigKind(from: nested)
        } else {
            kind = try SessionConfigKind(from: decoder)
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(description, forKey: .description)
        try kind.encode(to: encoder)
    }

    public init(id: SessionConfigId, name: String, description: String? = nil, kind: SessionConfigKind) {
        self.id = id
        self.name = name
        self.description = description
        self.kind = kind
    }
}

// MARK: - Session Config ID & Value ID

public struct SessionConfigId: Codable, Hashable, Sendable {
    public let value: String

    public init(_ value: String) {
        self.value = value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = try container.decode(String.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

public struct SessionConfigValueId: Codable, Hashable, Sendable {
    public let value: String

    public init(_ value: String) {
        self.value = value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = try container.decode(String.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

// MARK: - Session Config Kind

public enum SessionConfigKind: Codable, Sendable {
    case select(SessionConfigSelect)

    enum CodingKeys: String, CodingKey {
        case type
        case currentValue
        case options
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(String.self, forKey: .type)

        switch type {
        case "select":
            let select = SessionConfigSelect(
                currentValue: try container.decode(SessionConfigValueId.self, forKey: .currentValue),
                options: try container.decode(SessionConfigSelectOptions.self, forKey: .options)
            )
            self = .select(select)
        default:
            throw DecodingError.dataCorruptedError(
                forKey: .type,
                in: container,
                debugDescription: "Unsupported config kind: \(type)"
            )
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        switch self {
        case .select(let select):
            try container.encode("select", forKey: .type)
            try container.encode(select.currentValue, forKey: .currentValue)
            try container.encode(select.options, forKey: .options)
        }
    }
}

// MARK: - Session Config Select

public struct SessionConfigSelect: Codable, Sendable {
    public var currentValue: SessionConfigValueId
    public let options: SessionConfigSelectOptions

    enum CodingKeys: String, CodingKey {
        case currentValue
        case options
    }

    public init(currentValue: SessionConfigValueId, options: SessionConfigSelectOptions) {
        self.currentValue = currentValue
        self.options = options
    }
}

// MARK: - Session Config Select Options

public enum SessionConfigSelectOptions: Codable, Sendable {
    case ungrouped([SessionConfigSelectOption])
    case grouped([SessionConfigSelectGroup])

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let options = try? container.decode([SessionConfigSelectOption].self) {
            self = .ungrouped(options)
        } else if let groups = try? container.decode([SessionConfigSelectGroup].self) {
            self = .grouped(groups)
        } else {
            throw DecodingError.dataCorruptedError(
                in: container,
                debugDescription: "Invalid session config select options"
            )
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()

        switch self {
        case .ungrouped(let options):
            try container.encode(options)
        case .grouped(let groups):
            try container.encode(groups)
        }
    }
}

// MARK: - Session Config Select Option

public struct SessionConfigSelectOption: Codable, Sendable {
    public let value: SessionConfigValueId
    public let name: String
    public let description: String?

    enum CodingKeys: String, CodingKey {
        case value
        case name
        case label
        case description
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        value = try container.decode(SessionConfigValueId.self, forKey: .value)
        if let name = try container.decodeIfPresent(String.self, forKey: .name) {
            self.name = name
        } else if let label = try container.decodeIfPresent(String.self, forKey: .label) {
            self.name = label
        } else {
            throw DecodingError.keyNotFound(
                CodingKeys.name,
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Missing name/label for SessionConfigSelectOption"
                )
            )
        }
        description = try container.decodeIfPresent(String.self, forKey: .description)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(value, forKey: .value)
        try container.encode(name, forKey: .name)
        try container.encodeIfPresent(description, forKey: .description)
    }

    public init(value: SessionConfigValueId, name: String, description: String? = nil) {
        self.value = value
        self.name = name
        self.description = description
    }
}

// MARK: - Session Config Select Group

public struct SessionConfigGroupId: Codable, Hashable, Sendable {
    public let value: String

    public init(_ value: String) {
        self.value = value
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        value = try container.decode(String.self)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(value)
    }
}

public struct SessionConfigSelectGroup: Codable, Sendable {
    public let group: SessionConfigGroupId
    public let name: String
    public let options: [SessionConfigSelectOption]

    enum CodingKeys: String, CodingKey {
        case group
        case name
        case label
        case options
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let name = try container.decodeIfPresent(String.self, forKey: .name) {
            self.name = name
        } else if let label = try container.decodeIfPresent(String.self, forKey: .label) {
            self.name = label
        } else {
            throw DecodingError.keyNotFound(
                CodingKeys.name,
                DecodingError.Context(
                    codingPath: container.codingPath,
                    debugDescription: "Missing name/label for SessionConfigSelectGroup"
                )
            )
        }
        group = try container.decodeIfPresent(SessionConfigGroupId.self, forKey: .group) ?? SessionConfigGroupId(self.name)
        options = try container.decode([SessionConfigSelectOption].self, forKey: .options)
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(group, forKey: .group)
        try container.encode(name, forKey: .name)
        try container.encode(options, forKey: .options)
    }

    public init(group: SessionConfigGroupId, name: String, options: [SessionConfigSelectOption]) {
        self.group = group
        self.name = name
        self.options = options
    }
}
