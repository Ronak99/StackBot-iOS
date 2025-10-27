//
//  HistoryViewModel.swift
//  StackBot
//
//  Created by Ronak Punase on 03/10/25.
//

import Foundation

class HistoryViewModel : ObservableObject {
    @Published private var state = HistoryState()
    
    var threads: [ChatThread] {
        state.threads
    }
    
    func add(_ thread: ChatThread) {
        state.add(thread)
    }

    func has(_ thread: ChatThread) -> Bool {
        let index = state.threads.firstIndex(where: { $0.id == thread.id })
        return index != nil
    }
    
    func index(of thread: ChatThread) -> Int? {
        let index = state.threads.firstIndex(where: { $0.id == thread.id })
        return index
    }
    
    func update(_ thread: ChatThread) {
        DispatchQueue.main.async {
            if let index = self.index(of: thread) {
                self.state.threads[index] = thread
            }
        }
    }

    func find(byId id: UUID) -> ChatThread? {
        state.threads.first(where: { $0.id == id })
    }
}
