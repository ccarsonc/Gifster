//
//  InfoButton.swift
//  Gifster
//
//  Created by Carson Calloway
//


import SwiftUI

struct InfoButton: View {
    var title: String
    var message: String
    
    @State private var showAlert = false
    
    var body: some View {
        Button(action: {
            showAlert = true
        }) {
            Image(systemName: "info.circle")
                .imageScale(.large)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text(title),
                message: Text(message),
                dismissButton: .default(Text("OK"))
            )
        }
    }
}
