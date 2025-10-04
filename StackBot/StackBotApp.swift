//
//  StackBotApp.swift
//  StackBot
//
//  Created by Ronak Punase on 27/09/25.
//

import SwiftUI

@main
struct StackBotApp: App {
    var body: some Scene {
        WindowGroup {
            ChatView()
                .preferredColorScheme(.dark)
                .environmentObject(HistoryViewModel())
                .environmentObject(ChatViewModel())
        }
    }
}
