//
//  InsightsListView.swift
//  SoulmateDrawing
//
//  Created by Vitaliy Zagorodnov on 10.01.2026.
//

import SwiftUI

struct InsightsListView: View {
    let models: [InsightModel]
    
    var body: some View {
        ScrollView(.vertical) {
            LazyVStack(spacing: 16) {
                ForEach(models) { model in
                    Button(action: {}) {
                        BondsInsightCard(model: model)
                    }
                    .buttonStyle(.card)
                }
            }
        }
        .contentMargins(24, for: .scrollContent)
        .appBackground()
        .customBackButton()
        .toolbar {
            ToolbarButton(placement: .topBarTrailing) {
                Button(
                    action: {},
                    label: {
                        Image(systemName: "ellipsis")
                    }
                )
                .buttonStyle(.navigation)
            }
        }
    }
}

#Preview {
    NavigationStack {
        InsightsListView(models: [
            .init(id: "1", formattedDate: "Today", text: "What makes my friendship with Margo special?", pairText: "You & Margo", connectionType: .friend),
            .init(id: "2", formattedDate: "Nov 22", text: "Why do we sometimes misunderstand each other, and how can we communicate better", pairText: "You & Madison", connectionType: .partner),
            .init(id: "3", formattedDate: "Nov 19", text: "What creates the strongest emotional connection between us", pairText: "You & Liam", connectionType: .friend),
            .init(id: "4", formattedDate: "Nov 19", text: "What makes my friendship with Ivan special?", pairText: "You & Liam", connectionType: .partner)
        ])
    }
}
