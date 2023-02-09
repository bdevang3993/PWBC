//
//  PayerDetails.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 16/10/21.
//

import Foundation
import CoreData

struct PayerDetailsQuery {
    var arrPayerDetailsData: [NSManagedObject] = []
    mutating func getRecordsCount(record recordBlock: @escaping ((Int) -> Void)) {
        //1
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            recordBlock(-1)
            return
        }
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "PayerDetails")
        
        //3
        do {
            arrPayerDetailsData = try managedContext.fetch(fetchRequest)
        } catch _ as NSError {
            
        }
        if arrPayerDetailsData.count > 0 {
            let array = FileStoragePath.objShared.convertToJSONArray(moArray: arrPayerDetailsData)
            let lastobject = array[array.count - 1]
            recordBlock(Int(lastobject["id"] as! Int))
        }
        else {
            recordBlock(-1)
        }
    }
    mutating func saveinDataBase(id:Int,strName:String,strURL:String) -> Bool {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "PayerDetails",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        person.setValue(Int64(id), forKeyPath: "id")
        person.setValue(strName, forKeyPath: "name")
        person.setValue(strURL, forKeyPath: "strUrl")
        
        // 4
        do {
            try managedContext.save()
            arrPayerDetailsData.append(person)
            return true
        } catch _ as NSError {
            return false
        }
    }
    
    mutating func fetchAllData(record recordBlock: @escaping (([PayerData]) -> Void),failure failureBlock:@escaping ((Bool) -> Void))  {
        var allData = [[String:Any]]()
        var arrPayerDetail = [PayerData]()

          //1s
          guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            failureBlock(false)
              return
          }
          
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          //2
          let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "PayerDetails")
          //3
          do {
            arrPayerDetailsData = try managedContext.fetch(fetchRequest)
            if arrPayerDetailsData.count > 0 {
                arrPayerDetail.removeAll()
                let array = FileStoragePath.objShared.convertToJSONArray(moArray: arrPayerDetailsData)
                allData = array
                for value in allData {
                    let objCustomer = PayerData(strName: value["name"] as! String, strURL:value["strUrl"] as! String,id:Int(value["id"] as! Int64))
                    arrPayerDetail.append(objCustomer)
                }
                recordBlock(arrPayerDetail)
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
    }
    
    mutating func fetchAllDataByName(name:String,record recordBlock: @escaping (([PayerData]) -> Void),failure failureBlock:@escaping ((Bool) -> Void))  {
        var allData = [[String:Any]]()
        var arrPayerData = [PayerData]()

          //1s
          guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            failureBlock(false)
              return
          }

          let managedContext =
            appDelegate.persistentContainer.viewContext

          //2
          let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "PayerDetails")
            fetchRequest.predicate = NSPredicate(format: "name = %@",
                                                 argumentArray: [name])
          //3
          do {
            arrPayerDetailsData = try managedContext.fetch(fetchRequest)
            if arrPayerDetailsData.count > 0 {
                arrPayerData.removeAll()
                let array = FileStoragePath.objShared.convertToJSONArray(moArray: arrPayerDetailsData)
                allData = array
                for value in allData {
                    let objCustomer = PayerData(strName: value["name"] as! String, strURL:value["strUrl"] as! String,id:Int(value["id"] as! Int64))
                    arrPayerData.append(objCustomer)
                }
                recordBlock(arrPayerData)
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
    }
    
    func update(id:Int,name:String,strUrl:String) -> Bool {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PayerDetails")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "id = %d",
                                                 argumentArray: [Int64(id)])
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                results![0].setValue(name, forKeyPath: "name")
                results![0].setValue(strUrl, forKeyPath: "strUrl")
            }
        } catch {
        }
        
        do {
            try context.save()
            return true
        }
        catch {
            return false
        }
    }
    
    func delete(id:Int) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PayerDetails")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "id = %d",
                                                 argumentArray: [Int64(id)])
        var result:[NSManagedObject]?
        do {
             result = try context.fetch(fetchRequest) as? [NSManagedObject]
            context.delete(result![0])
        } catch {
        }
        
        do {
            try context.save()
            return true
        }
        catch {
            return false
        }
    }
    
    func deleteAllEntryFromDB() -> Bool {
        // Create Fetch Request
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "PayerDetails")
        
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(batchDeleteRequest)

        } catch {
            // Error Handling
        }
        return true
    }
    
}
