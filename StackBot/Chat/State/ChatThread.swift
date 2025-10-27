//
//  ChatThread.swift
//  StackBot
//
//  Created by Ronak Punase on 03/10/25.
//

import Foundation

struct ChatThread: Identifiable {
    private(set) var title: String?
    var id: UUID
    
    init(title: String? = nil) {
        self.id = UUID()
    }
    
    var getTitle: String {
        title ?? "No Title"
    }
    
    mutating func updateTitle(_ title: String) {
        self.title = title
    }
}
