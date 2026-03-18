//
//  ActivitySourceItem.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 19.03.2026.
//

import Foundation
import UIKit
import LinkPresentation

final class ActivitySourceItem: NSObject, UIActivityItemSource {
    private let item: Any
    private let title: String?
    private let icon: UIImage?
    
    init(item: Any, title: String?, icon: UIImage?) {
        self.item = item
        self.title = title
        self.icon = icon
    }
    
    func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        item
    }
    
    func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        item
    }
    
    func activityViewControllerLinkMetadata(_ activityViewController: UIActivityViewController) -> LPLinkMetadata? {
        let metadata = LPLinkMetadata()
        
        if let icon = icon {
            metadata.iconProvider = NSItemProvider(object: icon)
        } else if let icon = item as? UIImage {
            metadata.iconProvider = NSItemProvider(object: icon)
        }
        
        if let image = item as? UIImage {
            metadata.imageProvider = NSItemProvider(object: image)
        }
        
        if let title = title {
            metadata.title = title
        }
        
        if let urlString = item as? String, let itemURL = URL(string: urlString) {
            metadata.url = itemURL
        } else if let itemURL = item as? URL {
            metadata.url = itemURL
        }
        
        return metadata
    }
}
