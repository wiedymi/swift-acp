//
//  Logger+ACP.swift
//  ACP
//
//  Logging utility for ACP
//

import Foundation
import os.log

extension Logger {
    /// Default subsystem for ACP logging
    private static var acpSubsystem = "com.acp"

    /// Configure the logging subsystem (call once at initialization)
    public static func configureACPLogging(subsystem: String) {
        acpSubsystem = subsystem
    }

    /// Create a logger for a specific category
    public static func forCategory(_ category: String) -> Logger {
        Logger(subsystem: acpSubsystem, category: category)
    }

    /// Convenience logger for ACP
    public static let acp = Logger.forCategory("ACP")
}
