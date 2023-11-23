//
//  LoginViewController.swift
//  CoreDataPractice
//
//  Created by 홍세희 on 2023/11/23.
//

import UIKit
import CoreData

class LoginViewController: UIViewController {
    
    @IBOutlet var id: UITextField!
    @IBOutlet var password: UITextField!
    @IBOutlet var successStatus: UILabel!
    
    
    var managerObjectContext: NSManagedObjectContext?
    
    var tossWelcomeViewID: String = "알 수 없음"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initCoreData()
        password.isSecureTextEntry = true
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
    
    @IBAction func loginButton(_ sender: Any) {
        if let context = self.managerObjectContext, let entityDescription = NSEntityDescription.entity(forEntityName: "Informations", in: context) {
            let request: NSFetchRequest<Informations> = Informations.fetchRequest()
            
            request.entity = entityDescription
            
            if let id = id.text, let password = password.text {
                let pred = NSPredicate(format: "identifier = %@ AND password = %@", id, password)
                request.predicate = pred
            }
            
            do {
              let results = try context.fetch(request as! NSFetchRequest<NSFetchRequestResult>)
                if results.count > 0 {
//                    successStatus.text = "로그인 성공!"
                    let match = results[0] as! NSManagedObject
                    tossWelcomeViewID = match.value(forKey: "identifier") as! String
                    print(tossWelcomeViewID)
                    
                    guard let nextVC = self.storyboard?.instantiateViewController(identifier: "WelcomeView") as? WelcomeUserViewController else { return }
                    nextVC.showIdentifier = tossWelcomeViewID
                    self.navigationController?.pushViewController(nextVC, animated: true)
                    
                } else {
                    successStatus.text = "아이디 혹은 비밀번호 다시 확인!"
                }
           
            } catch let error {
                print(error.localizedDescription)
            }
        }
    }
}

