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
    
    @State var isVisible = true
    
    var body: some View {
        NavigationStack {
            contentBuilder
                .animation(.easeOut(duration: 0.3), value: chatViewModel.messages.isEmpty)
                .navigationTitle(chatViewModel.title ?? "Stack Bot")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    toolbarButton(
                        shouldShow: !historyViewModel.threads.isEmpty,
                        icon: "list.bullet",
                        placement: .topBarLeading
                    ) {
                        showHistorySheet = true
                    }
                    
                    toolbarButton(
                        shouldShow: !chatViewModel.userMessages.isEmpty,
                        icon: "plus",
                        placement: .topBarTrailing
                    ) {
                        chatViewModel.createNewChat(historyViewModel)
                    }
                }.sheet(isPresented: $showHistorySheet) {
                    HistoryView { selectedItem in
                        showHistorySheet = false
                        chatViewModel.loadHistory(historyViewModel, id: selectedItem.id)
                    }
                }
        }
    }
    
    var contentBuilder : some View {
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
    }
    
    
    @ToolbarContentBuilder
    func toolbarButton(
        shouldShow: Bool,
        icon: String,
        placement: ToolbarItemPlacement,
        action: @escaping () -> Void
    ) -> some ToolbarContent {
            if shouldShow {
                ToolbarItem(placement: placement) {
                    Button(action: action) {
                        Image(systemName: icon)
                    }
                }
            }
    }
    
    @ViewBuilder
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
                chatViewModel.onSendMessage(content: text, historyViewModel: historyViewModel)
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
