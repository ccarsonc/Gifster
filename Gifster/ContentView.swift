//
//  ContentView.swift
//  Gifster
//
//  Created by Carson Calloway
//

import SwiftUI
import ImageIO
import AppKit

struct ContentView: View {
    
    @EnvironmentObject var contentModel: ContentModel
    @State private var draggingItem: ImageItem?
    
    var body: some View {
        VStack(spacing: 20) {
            
            Image("gifsterlogo")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: .infinity, maxHeight: 150)
                .padding(.top, 20)
                .edgesIgnoringSafeArea(.horizontal)
            
            Button("Choose Images") {
                selectImages()
            }
            .padding(.horizontal)
            
            if !contentModel.imageItems.isEmpty {
                ScrollView(.horizontal) {
                    LazyHStack(spacing: 20) {
                        ForEach(contentModel.imageItems) { item in
                            ZStack(alignment: .topTrailing) {
                                AsyncImage(url: item.url) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 100, height: 100)
                                        .cornerRadius(8)
                                } placeholder: {
                                    ProgressView()
                                        .frame(width: 100, height: 100)
                                }
                                
                                Button(action: {
                                    deleteImage(item: item)
                                }) {
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.red)
                                        .background(Color.white.opacity(0.8))
                                        .clipShape(Circle())
                                }
                                .offset(x: 8, y: -8)
                            }
                            .onDrag {
                                self.draggingItem = item
                                return NSItemProvider(object: item.url.absoluteString as NSString)
                            }
                            .onDrop(of: [.text], delegate: ImageDropDelegate(item: item, items: $contentModel.imageItems, draggingItem: $draggingItem))
                        }
                    }
                    .padding(.horizontal)
                }
                .frame(height: 120)
                .frame(height: 120)
            }
            
            Button("Create GIF") {
                contentModel.saveGIF(to: contentModel.imageItems)
            }
            .disabled(contentModel.imageItems.isEmpty)
            .padding(.horizontal)
            
            Text(contentModel.statusMessage)
                .font(.footnote)
                .multilineTextAlignment(.center)
                .padding()
        }
        .frame(minWidth: 600, minHeight: 500)
        .padding()
    }
    
    private func selectImages() {
        let panel = NSOpenPanel()
        panel.allowsMultipleSelection = true
        panel.allowedContentTypes = [.image]
        panel.canChooseDirectories = false
        panel.begin { response in
            if response == .OK {
                contentModel.imageItems = panel.urls.map { ImageItem(url: $0) }
                contentModel.statusMessage = "\(contentModel.imageItems.count) image(s) selected"
            }
        }
    }
    
    private func deleteImage(item: ImageItem) {
        contentModel.imageItems.removeAll { $0 == item }
        contentModel.statusMessage = "\(contentModel.imageItems.count) image(s) remaining"
    }
}


#Preview {
    ContentView()
        .environmentObject(ContentModel.shared)
}
