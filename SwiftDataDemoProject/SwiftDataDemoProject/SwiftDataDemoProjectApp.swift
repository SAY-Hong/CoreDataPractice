//
//  SwiftDataDemoProjectApp.swift
//  SwiftDataDemoProject
//
//  Created by 홍세희 on 2023/12/28.
//

import SwiftUI
import SwiftData

@main
struct SwiftDataDemoProjectApp: App {
    // 모델 컨테이너 설정
    // 새로 생성한 TodoItem 추가.
    var sharedModelContainer: ModelContainer = {
        let schema = Schema([
            Item.self, TodoItem.self
        ])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }()

    var body: some Scene {
        WindowGroup {
            TodoItemView()
        }
        .modelContainer(sharedModelContainer)
    }
}
