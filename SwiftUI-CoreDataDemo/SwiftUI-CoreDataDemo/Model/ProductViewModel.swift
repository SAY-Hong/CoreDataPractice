//
//  ProductViewModel.swift
//  SwiftUI-CoreDataDemo
//
//  Created by 홍세희 on 2023/12/27.
//

import SwiftUI
import CoreData

class ProductViewModel: ObservableObject {
    static let shared = ProductViewModel()
    
    let container: NSPersistentContainer
    @Published var products = [Product]()
    
    init() {
        self.container = PersistenceController.shared.container
        fetchProduct()
    }
    
    func fetchProduct() {
        let fetchRequest: NSFetchRequest<Product> = Product.fetchRequest()
        
        do {
            self.products = try container.viewContext.fetch(fetchRequest)
        } catch {
            print("Error: fetchProduct init")
            print(error.localizedDescription)
        }
    }
    
    // 제품 추가하기
    func addProduct(name: String, quantity: String) {
        withAnimation {
            let product = Product(context: container.viewContext)
            product.name = name
            product.quantity = quantity

            saveContext()
        }
    }
    
    // 제품 저장하기
    // viewContext를 영구 저장소에 저장
    // 데이터를 저장하면, 최신 데이터를 가져와서 products 데이터 변수에 할당
    // 리스트뷰가 최신 데이터로 업데이트
    func saveContext() {
        do {
            try container.viewContext.save() // viewContext.save() : 변경 사항 저장! (삭제, 추가 등등.. )
        } catch {
            let error = error as NSError
            fatalError("Unresolved error \(error)")
        }
    }
    
    // 제품 삭제하기
    // offsets: 선택한 항목의 위치를 나타내는 List 항목의 오프셋 세트가 전달
    // saveContext() 항목이 삭제되면 변경사항을 영구 저장소에 저장
    func deleteProducts(offsets: IndexSet) {
        withAnimation {
            offsets.map { products[$0] }.forEach(container.viewContext.delete)
            
            saveContext()
        }
    }
}
