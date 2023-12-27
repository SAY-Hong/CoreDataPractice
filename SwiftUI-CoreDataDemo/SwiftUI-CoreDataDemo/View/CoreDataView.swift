//
//  CoreDataView.swift
//  SwiftUI-CoreDataDemo
//
//  Created by 홍세희 on 2023/12/27.
//

import SwiftUI

struct CoreDataView: View {
    @StateObject private var viewModel = ProductViewModel.shared
    
    @State var name: String = ""
    @State var quantity: String = ""
    
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
                        viewModel.addProduct(name: self.name, quantity: self.quantity)
                    }
                    Spacer()
                    
                    NavigationLink(destination: ResultView(name: name, viewContext: viewModel.container.viewContext)) {
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
                
                List {
                    ForEach(products) { product in
                        HStack {
                            Text(product.name ?? "Not found")
                            Spacer()
                            Text(product.quantity ?? "Not found")
                        }
                    }
                    .onDelete(perform: viewModel.deleteProducts)
                }
                .navigationTitle("Product Database")
            }
            .padding()
            .textFieldStyle(RoundedBorderTextFieldStyle())
        }
    }
}

#Preview {
    CoreDataView()
}
