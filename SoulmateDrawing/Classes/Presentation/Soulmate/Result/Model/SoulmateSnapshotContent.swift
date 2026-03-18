//
//  SoulmateSnapshotContent.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 19.03.2026.
//

import Foundation
import SwiftUI

struct SoulmateSnapshotContent {
    let image: Image?
    let points: [Point]
    
    struct Point: Hashable {
        let image: Image?
        let label: String
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(label)
        }
    }
}

extension SoulmateSnapshotContent {
    init(imageURL: URL?, mainPoints: [MainPoint]) async {
        let urls = ([imageURL] + mainPoints.map(\.iconURL)).compactMap { $0 }
        
        let images: [URL: Image?] = await withTaskGroup(of: (URL, Image?).self) { group in
            urls.forEach { url in
                group.addTask {
                    do {
                        let (data, _) = try await URLSession.shared.data(from: url)
                        return (url, UIImage(data: data).flatMap { Image(uiImage: $0) })
                    } catch {
                        return (url, nil)
                    }
                }
            }
            
            return await group.reduce(into: [:]) { partialResult, args in
                partialResult[args.0] = args.1
            }
        }
        
        let image = imageURL.flatMap { images[$0] ?? nil }
        
        let points = mainPoints.map { point in
            Point(
                image: point.iconURL.flatMap { images[$0] ?? nil },
                label: point.label
            )
        }
        
        self.init(
            image: image,
            points: points
        )
    }
}
