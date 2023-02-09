//
//  LicenceDetailQuery.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 08/09/21.
//

import Foundation
import CoreData

struct LicenceDetailsQuery {
    var LicenceDetailsData: [NSManagedObject] = []
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
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "LicenceDetail")
        
        //3
        do {
            LicenceDetailsData = try managedContext.fetch(fetchRequest)
        } catch _ as NSError {
            
        }
        if LicenceDetailsData.count > 0 {
            let array = FileStoragePath.objShared.convertToJSONArray(moArray: LicenceDetailsData)
            let lastobject = array[array.count - 1]
            recordBlock(Int(lastobject["licenceid"] as! Int64))
        }
        else {
            recordBlock(-1)
        }
    }
    mutating func saveinDataBase(licenceid:Int,licenceName:String,licenceNumber:String,registerDate: String,paymentDate:String,lastDate:String,licenceImage:Data,price:String) -> Bool {
        
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "LicenceDetail",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        person.setValue(Int64(licenceid), forKeyPath: "licenceid")
        person.setValue(licenceName, forKeyPath: "licenceName")
        person.setValue(licenceNumber, forKeyPath: "licenceNumber")
        person.setValue(registerDate, forKeyPath: "registerDate")
        person.setValue(paymentDate, forKeyPath: "paymentDate")
        person.setValue(lastDate, forKeyPath: "lastDate")
        person.setValue(price, forKeyPath: "price")
        person.setValue(licenceImage, forKeyPath: "licenceImage")
       
        // 4
        do {
            try managedContext.save()
            LicenceDetailsData.append(person)
            return true
        } catch _ as NSError {
            return false
        }
    }
    
    mutating func fetchAllData(record recordBlock: @escaping (([LicenceList]) -> Void),failure failureBlock:@escaping ((Bool) -> Void))  {
        var allData = [[String:Any]]()
        var arrListsData = [LicenceList]()

          //1
          guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            failureBlock(false)
              return
          }
          
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          //2
          let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "LicenceDetail")

          //3
          do {
            LicenceDetailsData = try managedContext.fetch(fetchRequest)
            
            if LicenceDetailsData.count > 0 {
                arrListsData.removeAll()
                let array = FileStoragePath.objShared.convertToJSONArray(moArray: LicenceDetailsData)
                allData = array
                for value in allData {
                    var data = Data()
                    if (value["licenceImage"] != nil) {
                        data = value["licenceImage"] as! Data
                    }
                    let objCustomer = LicenceList(licenceid: Int(value["licenceid"] as! Int64),  licenceName: value["licenceName"] as! String, licenceNumber: value["licenceNumber"] as! String, paymentDate: value["paymentDate"] as! String, registerDate: value["registerDate"] as! String, lastDate: value["lastDate"] as! String,price: value["price"] as! String, licenceImage: data,daysRemaining: 10000)
                    arrListsData.append(objCustomer)
                }
                recordBlock(arrListsData)
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
    }
    
    mutating func fetchAllDataByName(name:String,record recordBlock: @escaping (([LicenceList]) -> Void),failure failureBlock:@escaping ((Bool) -> Void))  {
        var allData = [[String:Any]]()
        var arrListsData = [LicenceList]()
        
        //1
        guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
            failureBlock(false)
            return
        }
        
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "LicenceDetail")
        fetchRequest.predicate = NSPredicate(format: "licenceName = %@",
                                             argumentArray: [name])
        //3
        do {
            LicenceDetailsData = try managedContext.fetch(fetchRequest)
            
            if LicenceDetailsData.count > 0 {
                arrListsData.removeAll()
                let array = FileStoragePath.objShared.convertToJSONArray(moArray: LicenceDetailsData)
                allData = array
                for value in allData {
                    var data = Data()
                    if (value["licenceImage"] != nil) {
                        data = value["licenceImage"] as! Data
                    }
                    let objCustomer = LicenceList(licenceid: Int(value["licenceid"] as! Int64),  licenceName: value["licenceName"] as! String, licenceNumber: value["licenceNumber"] as! String, paymentDate: value["paymentDate"] as! String, registerDate: value["registerDate"] as! String, lastDate: value["lastDate"] as! String,price: value["price"] as! String, licenceImage: data,daysRemaining: 10000)
                    arrListsData.append(objCustomer)
                }
                recordBlock(arrListsData)
            } else {
                failureBlock(false)
            }
        } catch _ as NSError {
            failureBlock(false)
        }
    }
    
    func update(licenceid:Int,licenceNumber:String,registerDate:String,paymentDate:String,lastDate:String,price:String,licenceImage:Data) -> Bool {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LicenceDetail")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "licenceid = %d",
                                                 argumentArray: [Int64(licenceid)])
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                //                // In my case, I only updated the first item in results
                results![0].setValue(licenceNumber, forKeyPath: "licenceNumber")
                results![0].setValue(registerDate, forKeyPath: "registerDate")
                results![0].setValue(paymentDate, forKeyPath: "paymentDate")
                results![0].setValue(lastDate, forKeyPath: "lastDate")
                results![0].setValue(price, forKeyPath: "price")
                results![0].setValue(licenceImage, forKeyPath: "licenceImage")
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
    
    func delete(licenceid:Int) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LicenceDetail")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "licenceid = %d",
                                                 argumentArray: [Int64(licenceid)])
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "LicenceDetail")
        
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
