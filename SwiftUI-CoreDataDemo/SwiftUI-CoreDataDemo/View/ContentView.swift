//
//  ContentView.swift
//  SwiftUI-CoreDataDemo
//
//  Created by 홍세희 on 2023/12/27.
//

import SwiftUI
import CoreData

struct ResultView: View {
    var name: String
    var viewContext: NSManagedObjectContext
    // 제품의 검색 결과가 List에 표시될 상태 프로퍼티
    @State var matches: [Product]?
    var body: some View {
        VStack {
            List {
                ForEach(matches ?? []) { match in
                    HStack {
                        Text(match.name ?? "Not found")
                        Spacer()
                        Text(match.quantity ?? "Not found")
                    }
                }
            }
            .navigationTitle("Product Database")
        }
        // 검색할 떄는 비동기로!
        .task {
            // Product 엔티티에서 fetchRequest 인스턴스를 가져온다.
            let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
            
            // Product 엔티티에서 검색 조건을 정의
            // CONTAINS: 검색에서 지정된 텍스트를 포함하는 모든 제품을 검색.
            fetchRequest.entity = Product.entity()
            //predicate -> 검색 조건
            fetchRequest.predicate = NSPredicate(format: "name CONTAINS %@", name)
            
            // 검색 결과를 matches에 할당.
            matches = try? viewContext.fetch(fetchRequest)
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

//#Preview {
//    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}
