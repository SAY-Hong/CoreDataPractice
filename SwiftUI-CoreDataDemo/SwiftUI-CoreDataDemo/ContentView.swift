//
//  ContentView.swift
//  SwiftUI-CoreDataDemo
//
//  Created by 홍세희 on 2023/12/27.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @State var name: String = ""
    @State var quantity: String = ""
    
    @Environment(\.managedObjectContext) private var viewContext

    // 관리 객체 가져오기
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item> // 연결해서 쓰는.. 바인딩 객체 같은 느낌!
    
    // MARK: sortDescriptors
    // [NSSortDescriptor(key: "name", ascending: true)] : name 기준으로 알파벳순으로 정렬하기
    @FetchRequest(entity: Product.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    private var products: FetchedResults<Product>

    var body: some View {
        NavigationStack {
            VStack {
                TextField("Product name", text: $name)
                TextField("Product quantity", text: $quantity)
                
                HStack {
                    Spacer()
                    Button("Add") {
                        addProduct()
                    }
                    Spacer()
                    
                    NavigationLink(destination: ResultView(name: name, viewContext: viewContext)) {
                        Text("Find")
                    }
                    Spacer()
                    Button("Clear") {
                        name = ""
                        quantity = ""
                    }
                    Spacer()
                }
                .padding()
                .frame(maxWidth: .infinity)
            }
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
        }
        
        NavigationView {
            List {
                ForEach(items) { item in
                    NavigationLink {
                        Text("Item at \(item.timestamp!, formatter: itemFormatter)")
                    } label: {
                        Text(item.timestamp!, formatter: itemFormatter)
                    }
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addItem) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            Text("Select an item")
        }
        .frame(height: 200)
    }

    // 제품 추가하기
    private func addProduct() {
        withAnimation {
            let product = Product(context: viewContext)
            product.name = self.name
            product.quantity = self.quantity

            saveContext()
        }
    }
    
    // 제품 저장하기
    // viewContext를 영구 저장소에 저장
    // 데이터를 저장하면, 최신 데이터를 가져와서 products 데이터 변수에 할당
    // 리스트뷰가 최신 데이터로 업데이트
    private func saveContext() {
        do {
            try viewContext.save() // viewContext.save() : 변경 사항 저장! (삭제, 추가 등등.. )
        } catch {
            let error = error as NSError
            fatalError("Unresolved error \(error)")
        }
    }
    
    // 제품 삭제하기
    // offsets: 선택한 항목의 위치를 나타내는 List 항목의 오프셋 세트가 전달
    // saveContext() 항목이 삭제되면 변경사항을 영구 저장소에 저장
    private func deleteProducts(offsets: IndexSet) {
        withAnimation {
            offsets.map { products[$0] }.forEach(viewContext.delete)
            
            saveContext()
        }
    }
    
    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()

            do {
                try viewContext.save() // viewContext.save() : 변경 사항 저장! (삭제, 추가 등등.. )
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

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
