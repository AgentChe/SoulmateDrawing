//
//  PersonListItem.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 19.03.2026.
//

import SwiftUI
import NukeUI

struct PersonListItem: View {
    let person: PersonModel
    let action: (PersonModel) -> Void
    
    var body: some View {
        Button(
            action: {
                action(person)
            },
            label: {
                HStack(spacing: 12.scale) {
                    LazyImage(source: person.singImage) { state in
                        if let image = state.image {
                            image
                        } else {
                            Circle()
                                .fill(.main300)
                        }
                    }
                    .frame(width: 45.scale, height: 50.scale)
                    .padding(.vertical, 2.scale)
                    
                    Text(person.name)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        )
    }
}
