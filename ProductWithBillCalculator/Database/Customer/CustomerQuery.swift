//
//  CustomerQuery.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 06/09/21.
//

import Foundation
import CoreData

struct CustomerQuery {
    var customerData: [NSManagedObject] = []
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
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "CustomerDetail")
        
        //3
        do {
            customerData = try managedContext.fetch(fetchRequest)
        } catch _ as NSError {
            
        }
        if customerData.count > 0 {
            let array = FileStoragePath.objShared.convertToJSONArray(moArray: customerData)
            let lastobject = array[array.count - 1]
            recordBlock(Int(lastobject["customerId"] as! Int64))
        }
        else {
            recordBlock(-1)
        }
    }
    mutating func saveinDataBase(customerId:Int,customerName:String,emailId:String,mobileNumber:String) -> Bool {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "CustomerDetail",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        person.setValue(Int64(customerId), forKeyPath: "customerId")
        person.setValue(customerName, forKeyPath: "customerName")
        person.setValue(emailId, forKeyPath: "emailId")
        person.setValue(mobileNumber, forKeyPath: "mobileNumber")
        
        // 4
        do {
            try managedContext.save()
            customerData.append(person)
            return true
        } catch _ as NSError {
            return false
        }
    }
    
    mutating func fetchAllData(record recordBlock: @escaping (([CustomerList]) -> Void),failure failureBlock:@escaping ((Bool) -> Void))  {
        var allData = [[String:Any]]()
        var arrCustomerLists = [CustomerList]()

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
            NSFetchRequest<NSManagedObject>(entityName: "CustomerDetail")
          //3
          do {
            customerData = try managedContext.fetch(fetchRequest)
            if customerData.count > 0 {
                arrCustomerLists.removeAll()
                let array = FileStoragePath.objShared.convertToJSONArray(moArray: customerData)
                allData = array
                for value in allData {
                    let objCustomer =  CustomerList(strCustomerName:value["customerName"] as! String, strEmailId:value["emailId"] as! String, strMobileNumber:value["mobileNumber"] as! String, customerId:Int(value["customerId"] as! Int64))
                    arrCustomerLists.append(objCustomer)
                }
                recordBlock(arrCustomerLists)
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
    }
    
    
    
    mutating func fetchDataByName(customerName:String,record recordBlock: @escaping (([CustomerList]) -> Void),failure failureBlock:@escaping ((Bool) -> Void))  {
        var allData = [[String:Any]]()
        var arrCustomerLists = [CustomerList]()

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
            NSFetchRequest<NSManagedObject>(entityName: "CustomerDetail")
            fetchRequest.predicate = NSPredicate(format: "customerName = %@",
                                                 argumentArray: [customerName])
          //3
          do {
            customerData = try managedContext.fetch(fetchRequest)
            if customerData.count > 0 {
                arrCustomerLists.removeAll()
                let array = FileStoragePath.objShared.convertToJSONArray(moArray: customerData)
                allData = array
                for value in allData {
                    let objCustomer =  CustomerList(strCustomerName:value["customerName"] as! String, strEmailId:value["emailId"] as! String, strMobileNumber:value["mobileNumber"] as! String, customerId:Int(value["customerId"] as! Int64))
                    arrCustomerLists.append(objCustomer)
                }
                recordBlock(arrCustomerLists)
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
    }
    
    
    
    
    func update(customerId:Int,emailId:String,mobileNumber:String) -> Bool {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CustomerDetail")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "customerId = %d",
                                                 argumentArray: [customerId])
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                //                // In my case, I only updated the first item in results
                
                results![0].setValue(emailId, forKeyPath: "emailId")
                results![0].setValue(mobileNumber, forKeyPath: "mobileNumber")
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
    
    func delete(customerId:Int) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CustomerDetail")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "customerId = %d",
                                                 argumentArray: [Int64(customerId)])
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CustomerDetail")
        
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
