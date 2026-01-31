//
//  Errors.swift
//  ACP
//
//  Error handling and error type definitions for ACP client
//

import Foundation

public enum ClientError: Error, LocalizedError, Sendable {
    case processNotRunning
    case processFailed(Int32)
    case invalidResponse
    case requestTimeout
    case encodingError
    case decodingError(Error)
    case agentError(JSONRPCError)
    case delegateNotSet
    case fileNotFound(String)
    case fileOperationFailed(String)

    public var errorDescription: String? {
        switch self {
        case .processNotRunning:
            return "Agent process is not running"
        case .processFailed(let code):
            return "Agent process failed with exit code \(code)"
        case .invalidResponse:
            return "Invalid response from agent"
        case .requestTimeout:
            return "Request timed out"
        case .encodingError:
            return "Failed to encode request"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .agentError(let jsonError):
            if let dataString = jsonError.data?.value as? String {
                return dataString
            }

            if let data = jsonError.data?.value as? [String: Any],
               let details = data["details"] as? String {
                if let detailsData = details.data(using: .utf8),
                   let json = try? JSONSerialization.jsonObject(with: detailsData) as? [String: Any],
                   let error = json["error"] as? [String: Any],
                   let message = error["message"] as? String {
                    return message
                }
                return details
            }

            return jsonError.message
        case .delegateNotSet:
            return "Internal error: Delegate not set"
        case .fileNotFound(let path):
            return "File not found: \(path)"
        case .fileOperationFailed(let message):
            return "File operation failed: \(message)"
        }
    }
}

actor ErrorHandler {
    // MARK: - Properties

    private let encoder: JSONEncoder

    // MARK: - Initialization

    init(encoder: JSONEncoder) {
        self.encoder = encoder
    }

    // MARK: - Error Response Creation

    func createErrorResponse(
        requestId: RequestId,
        code: Int,
        message: String
    ) throws -> JSONRPCResponse {
        let error = JSONRPCError(code: code, message: message, data: nil)
        return JSONRPCResponse(id: requestId, result: nil, error: error)
    }

    // MARK: - Error Handling

    func handleError(_ error: Error) -> String {
        if let clientError = error as? ClientError {
            return clientError.errorDescription ?? error.localizedDescription
        }
        return error.localizedDescription
    }

    func extractAgentError(from response: JSONRPCResponse) -> Error? {
        if let error = response.error {
            return ClientError.agentError(error)
        }
        return nil
    }
}

// MARK: - Typealiases for backward compatibility

@available(*, deprecated, renamed: "ClientError")
public typealias ACPClientError = ClientError
