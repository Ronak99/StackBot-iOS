//
//  HistoryView.swift
//  StackBot
//
//  Created by Ronak Punase on 01/10/25.
//

import SwiftUI

struct HistoryView: View {
    @EnvironmentObject var historyViewModel: HistoryViewModel
    var onSelect: (ChatThread) -> Void 
    
    
    var body: some View {
        NavigationStack {
            List(historyViewModel.threads) { thread in
                Button {
                    onSelect(thread)
                } label: {
                    Text(thread.getTitle)
                }
            }
            .navigationTitle("History")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    HistoryView { item in print(item) }
        .preferredColorScheme(.dark)
        .environmentObject(HistoryViewModel())
}
