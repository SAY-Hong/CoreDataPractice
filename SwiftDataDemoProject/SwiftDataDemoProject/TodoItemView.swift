//
//  TodoItemView.swift
//  SwiftDataDemoProject
//
//  Created by 홍세희 on 2023/12/28.
//

import SwiftUI
import SwiftData

struct TodoItemView: View {
    // @Query 속성은 필요한 데이터를 자동으로 가져온다.
    @Query private var todoItems: [TodoItem]
    @Environment(\.modelContext) private var modelContext
    var body: some View {
        NavigationStack {
            List {
                ForEach(todoItems) { todoItem in
                    HStack {
                        Text(todoItem.name)
                        Spacer()
                        if todoItem.isComplete {
                            Image(systemName: "checkmark")
                        }
                    }
                }
                // 삭제할 항목의 인덱스를 저장하는 인덱스 세트를 사용
                .onDelete(perform: { indexSet in
                    for index in indexSet {
                        modelContext.delete(todoItems[index])
                    }
                })
            }
            .navigationTitle("ToDoList")
            // 입력의 할 일 항목을 추가하기 위한 toolbar 추가
            .toolbar {
                Button("", systemImage: "plus") {
                    modelContext.insert(generateRandomTodoItem())
                }
            }
        }
    }
}

#Preview {
    TodoItemView()
        .modelContainer(previewModelContainer)
}
