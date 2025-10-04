//
//  ChatViewModel.swift
//  StackBot
//
//  Created by Ronak Punase on 27/09/25.
//

import SwiftUI
import OpenAI
 
class ChatViewModel: ObservableObject {
    @Published private var state = ChatViewState()
    
    var title: String? { state.thread.title }
    
    var loading: Bool { state.loading }
    
    var messages: [ChatViewState.Message] {
        state.messages
    }
    
    func onSendMessage(content: String) {
        let message = ChatViewState.Message.user(content: content, threadId: state.thread.id)
        
        state.add(message)
//        triggerDemoAI()
        triggerAI()
    }
    
    func createNewChat(_ model: HistoryViewModel) {
        if state.messages.isEmpty {
            return
        }
        
        if !model.has(state.thread) {
            
            model.add(thread: state.thread)
        }
        
        state = ChatViewState()
    }
    
    func loadHistory(_ model: HistoryViewModel, id selectedId: UUID) {
        if !state.messages.isEmpty {
            if !model.has(state.thread) {
                model.add(thread: state.thread)
            }
        }
        
        if let thread = model.find(byId: selectedId) {
            state = ChatViewState(thread: thread)
        }
    }
    
    func triggerDemoAI() {
        state.setLoading(to: true)
        
        let threadId = state.thread.id
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            let agentMessage = ChatViewState.Message.agent(content: "Hello, I am an agent.", threadId: threadId
            )
            self.state.add(agentMessage)
            self.state.setLoading(to: false)
        }
    }
    
    func triggerAI() {
        // this will request OpenAI and stream the response back
        // streamed response should be shown within the chat bubble
        
        // "org-ZUyazrWPCrQHsaO9276dtx2a"
        print(Secrets.orgKey)
        
        let configuration = OpenAI.Configuration(token: Secrets.openAIApiKey, organizationIdentifier: Secrets.orgKey, timeoutInterval: 60.0)
        let openAI = OpenAI(configuration: configuration)
        
        let threadId = state.thread.id
        
        let _ = Task {
            do {
                let openAICompatible: [ChatQuery.ChatCompletionMessageParam] = messages.map {
                    print($0)
                    switch($0.user) {
                        case .agent:
                            return .system(.init(content: .textContent($0.content)))
                        case .user:
                            return .user(.init(content: .string($0.content)))
                    }
                }
                
                state.setLoading(to: true)
                
                let result = try await openAI.chats(
                    query: .init(
                        messages: openAICompatible,
                        model: "gpt-4"
                    )
                )
                
                state.setLoading(to: false)
                
                state.add(ChatViewState.Message.agent(
                    content: result.choices.first?.message.content ?? "Nothing to show",
                    threadId: threadId
                ))
            } catch {
                print("Error occurred: \(error)")
            }
        }
        
        
    }
    
    func onReceiveMessage(content: String) {}
}
