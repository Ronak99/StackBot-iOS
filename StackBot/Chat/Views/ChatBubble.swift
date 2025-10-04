//
//  ChatBubble.swift
//  StackBot
//
//  Created by Ronak Punase on 30/09/25.
//

import SwiftUI

struct ChatBubble: View {
    let message: ChatViewState.Message
    let width: CGFloat
    
    var body: some View {
        Text(message.content)
            .padding()
            .foregroundStyle(.white)
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .fill(message.user == .user ? .blue : .gray)
            }
            .frame(maxWidth: (width - 16*2) * 0.75, alignment: message.user == .user ? .trailing : .leading)
            .frame(maxWidth: .infinity, alignment: message.user == .user ? .trailing : .leading)
            .padding(.horizontal, 16)
    }
}
