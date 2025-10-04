//
//  ChatView.swift
//  StackBot
//
//  Created by Ronak Punase on 27/09/25.
//

import SwiftUI

struct ChatView: View {
    @EnvironmentObject var chatViewModel : ChatViewModel
    @EnvironmentObject var historyViewModel : HistoryViewModel
    
    @State var text: String = ""
    @State var showHistorySheet: Bool = false
    
    var body: some View {
        NavigationStack {
            
            VStack(spacing: 16) {
                    // Main content area
                    ZStack {
                        // When there are no messages, show the icon in center
                        if chatViewModel.messages.isEmpty {
                            icon
                                .transition(.opacity.combined(with: .scale))
                        } else {
                            // When there are messages, show the message list
                            MessageList(messages: chatViewModel.messages)
                                .transition(.opacity)
                        }
                        
                    }
                    .frame(maxWidth: .infinity, maxHeight: chatViewModel.messages.isEmpty ? 180 : .infinity)
                
                    if chatViewModel.loading {
                        TypingIndicator()
                    }
                    
                    messageTextField.padding(.horizontal)
                }
                .animation(.easeOut(duration: 0.3), value: chatViewModel.messages.isEmpty)
                .navigationTitle(chatViewModel.title ?? "Stack Bot")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Button {
                            // show history
                            showHistorySheet = true
                        } label: {
                            Image(systemName: "list.bullet")
                        }
                    }
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            chatViewModel.createNewChat(historyViewModel)
                        } label: {
                            Image(systemName: "plus")
                        }
                    }
                }.sheet(isPresented: $showHistorySheet) {
                    HistoryView { selectedItem in
                        showHistorySheet = false
                        chatViewModel.loadHistory(historyViewModel, id: selectedItem.id)
                    }
                }
        }
    }
    
    var icon: some View {
        RoundedRectangle(cornerRadius: 32)
            .fill(.blue.opacity(0.5))
            .frame(width: 125, height: 125)
            .overlay {
                Text("S")
                    .font(.system(size: 65))
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
    }
    
    var messageTextField: some View {
        HStack {
            TextField("How can I help you today?", text: $text)
            Button {
                guard !text.isEmpty else { return }
                chatViewModel.onSendMessage(content: text)
                text = ""
            } label: {
                Image(systemName: "paperplane.fill")
                    .padding(.all, 6)
                    .foregroundStyle(.white)
                    .background(
                        Circle()
                            .fill(.blue)
                    )
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 12)
        .background {
            RoundedRectangle(cornerRadius: 12.0)
                .fill(.gray.opacity(0.2))
        }
    }
}

#Preview {
    ChatView()
        .preferredColorScheme(.dark)
        .environmentObject(HistoryViewModel())
        .environmentObject(ChatViewModel())

}
