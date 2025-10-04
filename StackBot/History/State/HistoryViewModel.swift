//
//  HistoryViewModel.swift
//  StackBot
//
//  Created by Ronak Punase on 03/10/25.
//

import Foundation

class HistoryViewModel : ObservableObject {
    private var state = HistoryState()
    
    var threads: [ChatThread] {
        state.threads
    }
    
    func add(thread: ChatThread) {
        state.add(thread)
        
        // go to open ai and figure out a proper title for this.
    }

    func has(_ thread: ChatThread) -> Bool {
        let index = state.threads.firstIndex(where: { $0.id == thread.id })
        return index != nil
    }

    func find(byId id: UUID) -> ChatThread? {
        state.threads.first(where: { $0.id == id })
    }
}
