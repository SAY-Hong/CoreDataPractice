//
//  SwiftUI_CoreDataDemoApp.swift
//  SwiftUI-CoreDataDemo
//
//  Created by 홍세희 on 2023/12/27.
//

import SwiftUI

@main
struct SwiftUI_CoreDataDemoApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
//            ContentView()
            CoreDataView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
