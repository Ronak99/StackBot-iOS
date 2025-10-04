//
//  ChatViewState.swift
//  StackBot
//
//  Created by Ronak Punase on 27/09/25.
//

import Foundation

struct ChatViewState {
    var thread: ChatThread
    var loading: Bool = false
    static private var allMessages: [Message] = []
    
    init(thread: ChatThread = ChatThread()) {
        self.thread = thread
    }
    
    var messages: [Message] {
        return ChatViewState.allMessages.filter { $0.threadId == thread.id }
    }
    
    mutating func add(_ message: Message) {
        ChatViewState.allMessages.append(message)
    }
    
    mutating func setLoading(to value: Bool) {
        loading = value
    }
    
    /// Message and it's related members
    enum User {
        case user
        case agent
    }
    
    enum MessageType {
        case general
    }

    
    struct Message: Identifiable, Equatable {
        // 0 for user, 1 for agent
        let user: User
        let content: String
        let type: MessageType
        let threadId: UUID
        
        var id: UUID
        
        init(sentBy user: User, content: String, type: MessageType, threadId: UUID) {
            self.user = user
            self.content = content
            self.type = type
            self.threadId = threadId
            self.id = UUID()
        }
    }
}

extension ChatViewState.Message {
    static func user(content: String, threadId: UUID) -> ChatViewState.Message {
        print("Sending user message to threadId: \(threadId)")
        return ChatViewState.Message(sentBy: .user, content: content, type: .general, threadId: threadId)
    }
    
    static func agent(content: String, threadId: UUID) -> ChatViewState.Message {
        print("Sending agent message to threadId: \(threadId)")
        return ChatViewState.Message(sentBy: .agent, content: content, type: .general, threadId: threadId)
    }
}

