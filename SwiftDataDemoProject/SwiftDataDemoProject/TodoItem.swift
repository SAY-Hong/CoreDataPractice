//
//  TodoItem.swift
//  SwiftDataDemoProject
//
//  Created by 홍세희 on 2023/12/28.
//

import Foundation
import SwiftData


// 앱의 데이터 모델을 생성.
// @Model : SwiftData는 자동으로 데이터 클래스에 대한 지속성을 활성화.
// Identifiable -> 아이디 부여
@Model
final class TodoItem: Identifiable {
    var id: UUID
    var name: String
    var isComplete: Bool
    
    init(id: UUID = UUID(), name: String = "", isComplete: Bool = false) {
        self.id = id
        self.name = name
        self.isComplete = isComplete
    }
}

func generateRandomTodoItem() -> TodoItem {
    let task = ["식료품 구입", "숙제 완료", "달리기", "요가 연습", "책 읽기", "블로그 게시물 작성", "집 청소"]
    
    let randomIndex = Int.random(in: 0..<task.count)
    let randomTask = task[randomIndex]
    
    return TodoItem(name: randomTask, isComplete: Bool.random())
}

// 샘플 데이터가 필요한 경우 미리보기용으로 특별히 사용자 정의 모델 컨테이너를 제작
// 인메모리 구성
// 미리보기용으로!!
@MainActor
let previewModelContainer: ModelContainer = {
    do {
        let container =  try ModelContainer(for: TodoItem.self, configurations: .init(isStoredInMemoryOnly: true))
        
        for _ in 1...10 {
            container.mainContext.insert(generateRandomTodoItem())
        }
        
        return container
    } catch {
        fatalError("Could not create ModelContainer: \(error)")
    }
}()
