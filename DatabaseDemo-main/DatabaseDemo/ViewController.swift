//
//  ViewController.swift
//  DatabaseDemo
//
//  Created by 박준영 on 11/22/23.
//

//TODO: 동명이인 구분하기

import UIKit

class ViewController: UIViewController {
    @IBOutlet var address: UITextField!
    @IBOutlet var name: UITextField!
    @IBOutlet var status: UILabel!
    @IBOutlet var phone: UITextField!
    
    var databasePath = "" //경로
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //MARK: 1. 데이터 베이스 초기화 하기
        initDB()
    }

    func initDB() {
        let filemgr = FileManager.default
        let dirPath = filemgr.urls(for: FileManager.SearchPathDirectory.documentDirectory, in: FileManager.SearchPathDomainMask.userDomainMask)
        
        databasePath = dirPath[0].appendingPathExtension("contacts.db").path
        
        //파일 있는지 확인하기
        if !filemgr.fileExists(atPath: databasePath) {
            let contactDB = FMDatabase(path: databasePath)
            
            //contactDB가 잘 열렸다!
            if contactDB.open() {
                let sqlStatement = "create table if not exists contacts ( id integer primary key autoincrement, name text, address text,phone text);"
                if !contactDB.executeStatements(sqlStatement) {//이 과정이 잘 됐으면 값이 반환되는 것이 있음.
                    print("error: \(contactDB.lastErrorMessage())")
                }
                contactDB.close() //마지막에 꼭 닫아주고 끝내기 -> 좀비 커넥션 생길수도..
            } else {
                print("error: \(contactDB.lastErrorMessage())") //잘 안열렸어..? 왜..? 를 알려주게 하기.
            }
        }
    }
    
    @IBAction func saveContact(_ sender: Any) {
        let contactDB = FMDatabase(path: databasePath)
        if contactDB.open() {
            let sqlStatement = "insert into contacts (name, address, phone) values ('\(name.text ?? "")', '\(address.text ?? "")', '\(phone.text ?? "")')"
            
            do {
                try contactDB.executeUpdate(sqlStatement, values: nil)
            } catch {
                status.text = "Contact Insert Fail"
            }
            
            contactDB.close()
            status.text = "Contact Added Successful"
            
            //초기화하기
            name.text = ""
            address.text = ""
            phone.text = ""
            
        } else {
            status.text = "DB File open Fail"
        }
    }
    
    @IBAction func findContact(_ sender: Any) {
        let contactDB = FMDatabase(path: databasePath)
        
        if contactDB.open() {
            let sqlStatement = "select address, phone from contacts where name='\(name.text ?? "")';"
            
            do {
                let results: FMResultSet? = try contactDB.executeQuery(sqlStatement, values: nil)
                
                //값 가져오기
//                if results?.next() == true {
//                    address.text = results?.string(forColumn: "address") //address에 있는 정보를 문자열로 넣는다.
//                    phone.text = results?.string(forColumn: "phone")
//                    status.text = "Record Found Successful"
//                } else {
//                    status.text = "Record Not Found."
//                    phone.text = ""
//                    address.text = ""
//                }
                //TODO: 동명이인 있나 확인하기
                while results?.next() == true {
                    let address = results?.string(forColumn: "address")
                    let phone = results?.string(forColumn: "phone")
                    print("\(address ?? "None"): \(phone ?? "None")")
                }
            } catch {
                print("error: \(contactDB.lastErrorMessage())")
            }
            
            contactDB.close()
            
        } else {
            print("error: \(contactDB.lastErrorMessage())")
        }
        
    }
}

struct Contact {
    let id: Int?
    let name: String?
    let address: String?
    let phone: String?
}
