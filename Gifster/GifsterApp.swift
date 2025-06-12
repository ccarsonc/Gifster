//
//  GifsterApp.swift
//  Gifster
//
//  Created by Carson Calloway
//

import SwiftUI

@main
struct GifsterApp: App {

    @StateObject var contentModel: ContentModel = ContentModel.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(contentModel)
        }
    }
}
