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
        ScrollView(Axis.Set.vertical) {
        VStack(alignment: HorizontalAlignment.center, spacing: 20) {
            
            Image("gifsterlogo")
                .resizable()
                .frame(width: 450, height: 150)
                .padding(.top, 5)
                .padding(.bottom)
            
            Button("Choose Images") {
                selectImages()
            }
            .padding(.horizontal)
            .padding(.top)
            
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
                    .padding()
                    .background(Color.gray.opacity(0.2).clipShape(RoundedRectangle(cornerRadius: 20)))
                    .padding(.horizontal)
                }
                .frame(height: 120)
                .frame(height: 120)
            }
            
            VStack(alignment: HorizontalAlignment.center, spacing: 10) {
                
                VStack {
                    HStack {
                        if (contentModel.frameDelay == 0.2) {
                            
                            Text("0.2 - Default")
                            
                        } else {
                            
                            Text(contentModel.frameDelay.description)
                            
                            Button {
                                contentModel.frameDelay = 0.2
                            } label: {
                                Text("Reset")
                            }
                        }
                        
                        InfoButton(title: "Frame Delay Information", message: "Setting the frame delay controls the amount of time in ms after each image. Higher values = longer GIFs.")
                            .padding(.vertical)
                    }
                    
                    HStack {
                        
                        Text("Frame Delay")
                            .padding(.vertical)
                        
                        Slider(
                            value: Binding(
                                get: { contentModel.frameDelay },
                                set: { contentModel.frameDelay = ($0 * 10).rounded() / 10 }
                            ),
                            in: 0...5,
                            step: 0.2
                        )
                    }
                }
                
                VStack {
                    HStack {
                        if (contentModel.loopCount == 0) {
                            Text("0 - Default (infinite)")
                        } else {
                            
                            Text(contentModel.loopCount.description)
                            
                            Button {
                                contentModel.loopCount = 0
                            } label: {
                                Text("Reset")
                            }
                        }
                        
                        InfoButton(title: "Loop Information", message: "Setting the amount of loops controls how many times you want your gif to play. Use 0 for infinite loop.")
                            .padding(.vertical)
                    }
                    
                    HStack {
                        
                        Text("Loops")
                        
                        Slider(
                            value: Binding(
                                get: { contentModel.loopCount },
                                set: { contentModel.loopCount = $0.rounded() }
                            ),
                            in: 0...10,
                            step: 1.0
                        )
                    }
                }
                
                Text(contentModel.statusMessage)
                    .font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding()
                
            }
            .padding()
            .background(Color.gray.opacity(0.2).clipShape(RoundedRectangle(cornerRadius: 20)))
            .padding(.top, 50)
            
            Button("Create GIF") {
                contentModel.saveGIF(to: contentModel.imageItems)
            }
            .disabled(contentModel.imageItems.isEmpty)
            .padding(.horizontal)
            
        }
        .frame(minWidth: 600, minHeight: 800)
        .padding()
    }
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
