import XCTest
@testable import ACP

final class ACPAgentTests: XCTestCase {

    func testCloseSessionInvokesCancelBeforeClose() async throws {
        let transport = TestTransport()
        let agent = Agent(transport: transport)
        let delegate = RecordingAgentDelegate()
        await agent.setDelegate(delegate)

        let startTask = Task {
            await agent.start()
        }
        defer {
            startTask.cancel()
        }

        let request = JSONRPCRequest(
            id: .number(1),
            method: "session/close",
            params: AnyCodable(["sessionId": "session-123"])
        )
        let requestData = try JSONEncoder().encode(request)
        await transport.pushMessage(requestData)

        let responseData = try await transport.nextSentMessage()
        let response = try JSONDecoder().decode(JSONRPCResponse.self, from: responseData)
        let events = await delegate.recordedEvents()

        XCTAssertEqual(response.id, .number(1))
        XCTAssertNil(response.error)
        XCTAssertEqual(events, [
            "cancel:session-123",
            "close:session-123",
        ])

        await transport.finish()
        _ = await startTask.result
    }
}

private actor TestTransport: Transport {
    private let messageContinuation: AsyncStream<Data>.Continuation
    nonisolated let messages: AsyncStream<Data>

    private var sentMessages: [Data] = []
    private var sentContinuation: CheckedContinuation<Data, Error>?
    private var connected = true

    init() {
        var continuation: AsyncStream<Data>.Continuation!
        self.messages = AsyncStream { streamContinuation in
            continuation = streamContinuation
        }
        self.messageContinuation = continuation
    }

    func send(_ data: Data) async throws {
        if let continuation = sentContinuation {
            sentContinuation = nil
            continuation.resume(returning: data)
        } else {
            sentMessages.append(data)
        }
    }

    func close() async {
        connected = false
        messageContinuation.finish()
    }

    var isConnected: Bool {
        get async { connected }
    }

    func pushMessage(_ data: Data) {
        messageContinuation.yield(data)
    }

    func finish() {
        connected = false
        messageContinuation.finish()
    }

    func nextSentMessage() async throws -> Data {
        if !sentMessages.isEmpty {
            return sentMessages.removeFirst()
        }

        return try await withCheckedThrowingContinuation { continuation in
            sentContinuation = continuation
        }
    }
}

private actor RecordingAgentDelegate: AgentDelegate {
    private var events: [String] = []

    func handleInitialize(_ request: InitializeRequest) async throws -> InitializeResponse {
        fatalError("Not used in this test")
    }

    func handleNewSession(_ request: NewSessionRequest) async throws -> NewSessionResponse {
        fatalError("Not used in this test")
    }

    func handlePrompt(_ request: SessionPromptRequest) async throws -> SessionPromptResponse {
        fatalError("Not used in this test")
    }

    func handleCancel(_ sessionId: SessionId) async throws {
        events.append("cancel:\(sessionId.value)")
    }

    func handleLoadSession(_ request: LoadSessionRequest) async throws -> LoadSessionResponse {
        fatalError("Not used in this test")
    }

    func handleListSessions(_ request: ListSessionsRequest) async throws -> ListSessionsResponse {
        fatalError("Not used in this test")
    }

    func handleCloseSession(_ request: CloseSessionRequest) async throws -> CloseSessionResponse {
        events.append("close:\(request.sessionId.value)")
        return CloseSessionResponse()
    }

    func recordedEvents() -> [String] {
        events
    }
}
