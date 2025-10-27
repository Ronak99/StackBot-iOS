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
    
    var openAI: OpenAI
    
    var messages: [ChatViewState.Message] {
        state.messages
    }
    
    var userMessages: [ChatViewState.Message] {
        state.userMessages
    }
    
    init() {
        let configuration = OpenAI.Configuration(token: Secrets.openAIApiKey, organizationIdentifier: Secrets.orgKey, timeoutInterval: 60.0)
        openAI = OpenAI(configuration: configuration)
    }
    
    func onSendMessage(content: String, historyViewModel: HistoryViewModel) {
        let message = ChatViewState.Message.user(content: content, threadId: state.thread.id)
        
        // no message has been added yet
        if state.userMessages.isEmpty {
            state.thread.updateTitle(content)
            
            if historyViewModel.has(state.thread) {
                historyViewModel.update(state.thread)
            } else {
                historyViewModel.add(state.thread)
            }
            
        }
        
        state.add(message)
        
//        triggerDemoAI(historyViewModel, thread: state.thread)
        triggerAI(historyViewModel, thread: state.thread, noAgentMessage: state.agentMessages.isEmpty)
    }
    
    func createNewChat(_ historyViewModel: HistoryViewModel) {
        if state.messages.isEmpty {
            return
        }
        
        state = ChatViewState()
        
        if !historyViewModel.has(state.thread) {
            historyViewModel.add(state.thread)
        }
    }
    
    func loadHistory(_ model: HistoryViewModel, id selectedId: UUID) {
        if let thread = model.find(byId: selectedId) {
            state = ChatViewState(thread: thread)
        }
    }
    
    func triggerDemoAI(_ historyViewModel: HistoryViewModel, thread: ChatThread) {
        state.setLoading(to: true)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 8) {
            let response = "\(thread.id)"
            let agentMessage = ChatViewState.Message.agent(content: response, threadId: thread.id)
            
            let threadTitle = "New thread title"
            
            if thread.id == self.state.thread.id {
                self.state.thread.updateTitle(threadTitle)
            }
            
            var thread = thread
            thread.updateTitle(threadTitle);
            historyViewModel.update(thread)
            
            self.state.add(agentMessage)
            self.state.setLoading(to: false)
        }
    }
    
    func getAIResponse(prompt: String, messages: [ChatQuery.ChatCompletionMessageParam], ignoreDoubleQuotes: Bool = false) async throws -> String {
        var messages = messages
        messages.append(.user(.init(content: .string(prompt))))
        
        let result = try await openAI.chats(
            query: .init(
                messages: messages,
                model: "gpt-4"
            )
        )
        
        // Extract the content
            if var content = result.choices.first?.message.content {
                if ignoreDoubleQuotes {
                    content = content.replacingOccurrences(of: "\"", with: "")
                }
                return content
            } else {
                return "No response received."
            }
    }
    
    func triggerAI(_ historyViewModel: HistoryViewModel, thread: ChatThread, noAgentMessage: Bool) {
        let _ = Task {
            do {
                let gptCompatible: [ChatQuery.ChatCompletionMessageParam] = messages.map {
                    switch($0.user) {
                        case .agent:
                            return .system(.init(content: .textContent($0.content)))
                        case .user:
                            return .user(.init(content: .string($0.content)))
                    }
                }
                
                state.setLoading(to: true)
                
                let aiResponse = try await getAIResponse(
                    prompt: "Be a helpful agent and reply with useful answers",
                    messages: gptCompatible
                )
                
                state.setLoading(to: false)
                
                state.add(
                    ChatViewState.Message.agent(content: aiResponse, threadId: thread.id)
                )
                
                // if there were no agent messages back when everything started, only then should I generate a title
                if noAgentMessage {
                    let aiTitle = try await getAIResponse(
                        prompt: "Scan through the list of messages and suggest an appropriate title for the conversation. Make sure that the title is less than or equal to 5 words.",
                        messages: gptCompatible,
                        ignoreDoubleQuotes: true,
                    )
                    
                    if thread.id == self.state.thread.id {
                        self.state.thread.updateTitle(aiTitle)
                    }
                    
                    var thread = thread
                    thread.updateTitle(aiTitle);
                    historyViewModel.update(thread)
                }
            } catch {
                print("Error occurred: \(error)")
            }
        }
    }
}

