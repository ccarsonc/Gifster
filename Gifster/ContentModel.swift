//
//  ContentModel.swift
//  Gifster
//
//  Created by Carson Calloway
//

import SwiftUI
import UniformTypeIdentifiers

@MainActor
final class ContentModel: NSObject, ObservableObject {
    
    static let shared = ContentModel()
    private override init() {}
    
    //@Published var imageURLs: [URL] = []
    @Published var imageItems: [ImageItem] = []
    @Published var statusMessage: String = "No images selected"
    
    func createGIF(from urls: [URL]) {
        let destinationURL = FileManager.default.homeDirectoryForCurrentUser
            .appendingPathComponent("Desktop/animated.gif")
        
        var destination: CGImageDestination?
        
        if #available(macOS 12.0, *) {
            destination = CGImageDestinationCreateWithURL(destinationURL as CFURL, UTType.gif.identifier as CFString, urls.count, nil)
        } else {
            destination = CGImageDestinationCreateWithURL(destinationURL as CFURL, kUTTypeGIF, urls.count, nil)
        }
        let frameDelay = 0.2
        let gifProperties = [kCGImagePropertyGIFDictionary: [kCGImagePropertyGIFLoopCount: 0]] as CFDictionary
        let frameProperties = [kCGImagePropertyGIFDictionary: [kCGImagePropertyGIFDelayTime: frameDelay]] as CFDictionary
        
        guard let destination else {
            statusMessage = "Failed to create GIF destination"
            return
        }
        CGImageDestinationSetProperties(destination, gifProperties)
        
        for url in urls {
            if let image = NSImage(contentsOf: url),
               let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) {
                CGImageDestinationAddImage(destination, cgImage, frameProperties)
            }
        }
        
        if CGImageDestinationFinalize(destination) {
            statusMessage = "GIF saved to Desktop!"
        } else {
            statusMessage = "Failed to save GIF"
        }
    }
    
    func saveGIF(to items: [ImageItem]) {
        let savePanel = NSSavePanel()
        savePanel.allowedContentTypes = [UTType.gif]
        savePanel.nameFieldStringValue = "animated.gif"
        savePanel.begin { response in
            if response == .OK, let destinationURL = savePanel.url {
                self.generateGIF(from: items.map { $0.url }, to: destinationURL)
            }
        }
    }
    
    private func generateGIF(from urls: [URL], to destinationURL: URL) {
        guard let destination = CGImageDestinationCreateWithURL(destinationURL as CFURL, UTType.gif.identifier as CFString, urls.count, nil) else {
            DispatchQueue.main.async {
                self.statusMessage = "Failed to create GIF destination"
            }
            return
        }
        
        let frameDelay = 0.2
        let gifProperties = [
            kCGImagePropertyGIFDictionary: [
                kCGImagePropertyGIFLoopCount: 0
            ]
        ] as CFDictionary
        
        let frameProperties = [
            kCGImagePropertyGIFDictionary: [
                kCGImagePropertyGIFDelayTime: frameDelay
            ]
        ] as CFDictionary
        
        CGImageDestinationSetProperties(destination, gifProperties)
        
        for url in urls {
            guard let nsImage = NSImage(contentsOf: url),
                  let cgImage = nsImage.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
                continue // skip invalid image
            }
            
            CGImageDestinationAddImage(destination, cgImage, frameProperties)
        }
        
        let success = CGImageDestinationFinalize(destination)
        DispatchQueue.main.async {
            self.statusMessage = success ? "GIF saved successfully!" : "Failed to save GIF"
        }
    }
}
