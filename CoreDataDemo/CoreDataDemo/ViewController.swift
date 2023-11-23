//
//  ViewController.swift
//  CoreDataDemo
//
//  Created by 홍세희 on 2023/11/22.
//

import UIKit
import CoreData //CoreData import하기

class ViewController: UIViewController {
    
    @IBOutlet var address: UITextField!
    @IBOutlet var name: UITextField!
    @IBOutlet var phone: UITextField!
    @IBOutlet var status: UILabel!
    
    var managerObjectContext: NSManagedObjectContext? //메모리 상에서 저장된 애
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initCoreData()
    }

    private func initCoreData() {
        //영구 컨테이너 저장
        let container = NSPersistentContainer(name: "CoreDataDemo")
        container.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("initCoreData Error: \(error)")
            } else {
                self.managerObjectContext = container.viewContext
            }
        }
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if let context = self.managerObjectContext, let entityDescription = NSEntityDescription.entity(forEntityName: "Contacts", in: context) {
            let contact = Contacts(entity: entityDescription, insertInto: managerObjectContext) //앱 실행 시 Contacts 가 자동생성되는거라서 오류 뜨는것!
            //entityDescription -> 진짜 코어로 만들어진 아이
            
            contact.name = name.text
            contact.address = address.text
            contact.phone = phone.text
            
            do {
                try managerObjectContext?.save() 
                //데이터 일관성 지켜야한다.
                //변경 사항이 있으면 변경 사항 있는 애들을 싹 다 저장해준다.
                name.text = ""
                address.text = ""
                phone.text = ""
                status.text = "Contact Added!"
            } catch {
                status.text = error.localizedDescription
            }
            
        }
    }
    
    @IBAction func findButton(_ sender: Any) {
        if let context = self.managerObjectContext, let entityDescription = NSEntityDescription.entity(forEntityName: "Contacts", in: context) {
            let request: NSFetchRequest<Contacts> = Contacts.fetchRequest()
            
            request.entity = entityDescription
            
            if let name = name.text {
                let pred = NSPredicate(format: "(name = %@)", name) //??????????뭔 소릴까나 정말로~
                request.predicate = pred
            }
            
            do {
                let results = try context.fetch(request as! NSFetchRequest<NSFetchRequestResult>) //검색 결과를 나타내게 해주는 코드인가바 -> 검색 기준을 지정하는 fetch 요청.
                
                if results.count > 0 {
                    let match = results[0] as! NSManagedObject
                    name.text = match.value(forKey: "name") as? String
                    address.text = match.value(forKey: "address") as? String
                    phone.text = match.value(forKey: "phone") as? String
                    status.text = "Find Successful. \(results.count)" //동명이인 몇명인지 알 수 있게 해주는..!
                } else {
                    status.text = "Try to check 'Name' or 'SAVE' your information."
                }
            
            } catch let error {
                status.text = error.localizedDescription
            }
        }
    }//
}

//import UIKit
//import CoreData
//
//class MembershipController: UIViewController {
//
//    @IBOutlet var id: UITextField!
//    @IBOutlet var password: UITextField!
//    @IBOutlet var status: UILabel!
//
//    var managerObjectContext: NSManagedObjectContext?
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        // Do any additional setup after loading the view.
//        initCoreData()
//    }
//
//    func initCoreData() {
//        let container = NSPersistentContainer(name: "CoreDataPractice")
//        container.loadPersistentStores { description, error in
//            if let error = error {
//                fatalError("initCoreData Error: \(error)")
//            } else {
//                self.managerObjectContext = container.viewContext
//            }
//        }
//    }
//    @IBAction func loginButton(_ sender: Any) {
//
//    }
//
//    @IBAction func saveButton(_ sender: Any) {
//        if let context = self.managerObjectContext, let entityDescription = NSEntityDescription.entity(forEntityName: "Informations", in: context) {
//
//            let request: NSFetchRequest<Informations> = Informations.fetchRequest()
//            let information = Informations(entity: entityDescription, insertInto: managerObjectContext)
//
//            //TODO: ID 중복확인 및 ID 입력하지 않았을 경우 제약조건 걸기
//            request.entity = entityDescription
//
//            if let id = id.text {
//                let pred = NSPredicate(format: "identifier = %@", id)
//                request.predicate = pred
//            }
//
//            do {
//              let results = try context.fetch(request as! NSFetchRequest<NSFetchRequestResult>)
//                if results.count > 0 {
//                    status.text = "중복된 아이디입니다. "
//                } else {
//                    if id.text == "" {
//                        status.text = "아이디가 입력되지 않았습니다. 다시 입력해주세요."
//                    } else {
//                        information.identifier = id.text
//                        information.password = password.text
//
//                        do {
//                            try managerObjectContext?.save()
//                            id.text = ""
//                            password.text = ""
//                            status.text = "회원가입이 정상적으로 되었습니다."
//                        } catch {
//                            status.text = error.localizedDescription
//                        }
//
//                    }
//                }
//
//            } catch let error {
//                status.text = error.localizedDescription
//            }
//
//
////            if id.text == "" {
////                status.text = "아이디가 입력되지 않았습니다. 다시 입력해주세요."
////            } else {
////                information.identifier = id.text
////                information.password = password.text
////
////                do {
////                    try managerObjectContext?.save()
////                    id.text = ""
////                    password.text = ""
////                    status.text = "회원가입이 정상적으로 되었습니다."
////                } catch {
////                    status.text = error.localizedDescription
////                }
////
////            }
//
//            //TODO: 아이디 설정 시 대소문자 구분하게 작성?
//        }
//    }
//
//    @IBAction func findButton(_ sender: Any) {
//        if let context = self.managerObjectContext, let entityDescription = NSEntityDescription.entity(forEntityName: "Informations", in: context) {
//            let request: NSFetchRequest<Informations> = Informations.fetchRequest()
//
//            request.entity = entityDescription
//
//            if let id = id.text {
//                let pred = NSPredicate(format: "identifier = %@", id)
//                request.predicate = pred
//            }
//
//            do {
//              let results = try context.fetch(request as! NSFetchRequest<NSFetchRequestResult>)
//                if results.count > 0 {
//                    let match = results[0] as! NSManagedObject
//                    id.text = match.value(forKey: "identifier") as? String
//                    password.text = match.value(forKey: "password") as? String
//
//                    status.text = "Find Successful. \(results.count)"
//                } else {
//                    status.text = "Try to check 'Name' or 'SAVE' your information."
//                }
//
//            } catch let error {
//                status.text = error.localizedDescription
//            }
//        }
//    }
//}
