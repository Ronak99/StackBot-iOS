//
//  MessageLis.swift
//  StackBot
//
//  Created by Ronak Punase on 27/09/25.
//

import SwiftUI

struct MessageList: View {
    let messages: [ChatViewState.Message]
    
    var body: some View {
                ScrollViewReader { proxy in
                    GeometryReader { geometry in
                        ScrollView {
                            ForEach(messages) { message in
                                ChatBubble(message: message, width: geometry.size.width)
                            }
                        }
                    }
                }
                .defaultScrollAnchor(.bottom)        
        }
}

//#Preview {
//    MessageList(messages: [])
//}
