//
//  HistoryItem.swift
//  StackBot
//
//  Created by Ronak Punase on 02/10/25.
//

import Foundation

struct HistoryState {
    var threads: [ChatThread] = []
    
    mutating func add(_ thread: ChatThread) {
        threads.append(thread)
    }
}
