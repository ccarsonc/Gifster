//
//  ImageDropDelegate.swift
//  Gifster
//
//  Created by Carson Calloway
//

import SwiftUI

struct ImageDropDelegate: DropDelegate {
    let item: ImageItem
    @Binding var items: [ImageItem]
    @Binding var draggingItem: ImageItem?

    func performDrop(info: DropInfo) -> Bool {
        self.draggingItem = nil
        return true
    }

    func dropEntered(info: DropInfo) {
        guard let draggingItem = draggingItem, draggingItem != item,
              let fromIndex = items.firstIndex(of: draggingItem),
              let toIndex = items.firstIndex(of: item) else {
            return
        }

        if items[toIndex] != draggingItem {
            withAnimation {
                items.move(fromOffsets: IndexSet(integer: fromIndex), toOffset: toIndex > fromIndex ? toIndex + 1 : toIndex)
            }
        }
    }
}
