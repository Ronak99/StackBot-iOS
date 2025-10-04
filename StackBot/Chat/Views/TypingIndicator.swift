//
//  TypingIndicator.swift
//  StackBot
//
//  Created by Ronak Punase on 28/09/25.
//

import SwiftUI

struct TypingIndicator: View {
    @State private var animating = false
    
    var body: some View {
        HStack {
            ForEach(0...2, id: \.self) {index in
                Circle()
                    .fill(.white)
                    .offset(y: animating ? -2 : 0)
                    .animation(
                        .easeInOut.repeatForever().delay(Double(index) * 0.15),
                        value: animating
                    )
            }
        }
        .padding(.vertical, 20)
        .padding(.horizontal, 12)
        .background {
            RoundedRectangle(cornerRadius: 12).fill(.gray)
        }
        .frame(maxWidth: 60)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 16)
        .onAppear {
            animating = true
        }
    }
}

#Preview {
    TypingIndicator()
}
