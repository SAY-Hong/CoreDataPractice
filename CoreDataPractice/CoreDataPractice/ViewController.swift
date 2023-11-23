//
//  ViewController.swift
//  CoreDataPractice
//
//  Created by 홍세희 on 2023/11/23.
//

import UIKit
import CoreData

class MembershipController: UIViewController {
    private var flag: Bool = false
    
    @IBOutlet var id: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var phone: UITextField!
    @IBOutlet var name: UITextField!
    @IBOutlet var idStatus: UILabel!
    
    @IBOutlet var status: UILabel!
    
    var managerObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        initCoreData()
    }

    func initCoreData() {
        let container = NSPersistentContainer(name: "CoreDataPractice")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("initCoreData Error: \(error)")
            } else {
                self.managerObjectContext = container.viewContext
            }
        }
    }
    
    @IBAction func checkIDtwice(_ sender: Any) {
        if let context = self.managerObjectContext, let entityDescription = NSEntityDescription.entity(forEntityName: "Informations", in: context) {
            let request: NSFetchRequest<Informations> = Informations.fetchRequest()
            
            request.entity = entityDescription
            
            if let id = id.text {
                let pred = NSPredicate(format: "identifier = %@", id)
                request.predicate = pred
            }
            
            do {
                let results = try context.fetch(request as! NSFetchRequest<NSFetchRequestResult>)
                
                if results.count > 0 {
                    idStatus.text = "사용 불가능한 아이디입니다. "
                } else {
                    idStatus.text = "사용 가능한 아이디입니다. "
                    flag = true
                }
            
            } catch let error {
                status.text = error.localizedDescription
            }
        }
    }
    
    @IBAction func saveInformation(_ sender: Any) {
        if flag {
            if let context = self.managerObjectContext, let entityDescription = NSEntityDescription.entity(forEntityName: "Informations", in: context) {
                let information = Informations(entity: entityDescription, insertInto: managerObjectContext)
                
                information.identifier = id.text
                information.password = password.text
                information.name = name.text
                information.phone = phone.text
                
                do {
                    try managerObjectContext?.save()
                    id.text = ""
                    password.text = ""
                    name.text = ""
                    phone.text = ""
                    idStatus.text = ""
                    status.text = "회원가입이 정상적으로 되었습니다."
                    
                } catch {
                    status.text = error.localizedDescription
                }
            }
            self.dismiss(animated: true)
        } else {
            status.text = "아이디 중복확인을 먼저 진행해주세요."
        }
        
    }
    
}

