//
//  OrderDetailsQuery.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 30/09/21.
//

import Foundation
import CoreData

struct OrderDetailsQuery {
    var billDescriptionData: [NSManagedObject] = []
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
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "OrderDetail")
        
        //3
        do {
            billDescriptionData = try managedContext.fetch(fetchRequest)
        } catch _ as NSError {
            
        }
        if billDescriptionData.count > 0 {
            let array = FileStoragePath.objShared.convertToJSONArray(moArray: billDescriptionData)
            let lastobject = array[array.count - 1]
            recordBlock(Int(lastobject["productDetailId"] as! Double))
        }
        else {
            recordBlock(-1)
        }
    }
    mutating func saveinDataBase(productDetailId:Int,date:String,time:String,advance:Double,remains:Double,pickupNumber:String,customerNumber:String) -> Bool {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "OrderDetail",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
       
        person.setValue(Int64(productDetailId), forKeyPath: "productDetailId")
        person.setValue(date, forKeyPath: "date")
        person.setValue(time, forKeyPath: "time")
        person.setValue(advance, forKeyPath: "advance")
        person.setValue(remains, forKeyPath: "remains")
        person.setValue(pickupNumber, forKeyPath: "pickupNumber")
        person.setValue(customerNumber, forKeyPath: "customerNumber")
        // 4
        do {
            try managedContext.save()
            billDescriptionData.append(person)
            return true
        } catch _ as NSError {
            return false
        }
    }
    
    mutating func fetchAllData(record recordBlock: @escaping (([AdvanceDetail]) -> Void),failure failureBlock:@escaping ((Bool) -> Void))  {
        var allData = [[String:Any]]()
        var arrAdvanceList = [AdvanceDetail]()

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
            NSFetchRequest<NSManagedObject>(entityName: "OrderDetail")
          //3
          do {
            billDescriptionData = try managedContext.fetch(fetchRequest)
            if billDescriptionData.count > 0 {
                arrAdvanceList.removeAll()
                let array = FileStoragePath.objShared.convertToJSONArray(moArray: billDescriptionData)
                allData = array
                for value in allData {
                    let objCustomer =  AdvanceDetail(productDetailId: value["productDetailId"] as! Int, date: value["date"] as! String, time: value["time"] as! String, advance: value["advance"] as! Double, remains: value["remains"] as! Double, pickupNumber: value["pickupNumber"] as! String,customerNumber: value["customerNumber"] as! String)
                    arrAdvanceList.append(objCustomer)
                }
                recordBlock(arrAdvanceList)
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
    }
    
    mutating func fetchAllDataByDate(date:String,record recordBlock: @escaping (([AdvanceDetail]) -> Void),failure failureBlock:@escaping ((Bool) -> Void))  {
        var allData = [[String:Any]]()
        var arrAdvanceList = [AdvanceDetail]()
        
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
            NSFetchRequest<NSManagedObject>(entityName: "OrderDetail")
        fetchRequest.predicate = NSPredicate(format: "date = %@",
                                             argumentArray: [date])
        //3
        do {
            billDescriptionData = try managedContext.fetch(fetchRequest)
            if billDescriptionData.count > 0 {
                arrAdvanceList.removeAll()
                let array = FileStoragePath.objShared.convertToJSONArray(moArray: billDescriptionData)
                allData = array
                for value in allData {
                    let objCustomer =  AdvanceDetail(productDetailId: value["productDetailId"] as! Int, date: value["date"] as! String, time: value["time"] as! String, advance: value["advance"] as! Double, remains: value["remains"] as! Double, pickupNumber: value["pickupNumber"] as! String,customerNumber: value["customerNumber"] as! String)
                    arrAdvanceList.append(objCustomer)
                }
                recordBlock(arrAdvanceList)
            } else {
                failureBlock(false)
            }
        } catch _ as NSError {
            failureBlock(false)
        }
    }
    
    func update(productDetailId:Int,date:String,time:String,advance:Double,remains:Double,pickupNumber:String) -> Bool {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OrderDetail")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "productDetailId = %d",
                                                 argumentArray: [Int64(productDetailId)])
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                //                // In my case, I only updated the first item in results
                
                results![0].setValue(date, forKeyPath: "date")
                results![0].setValue(time, forKeyPath: "time")
                results![0].setValue(advance, forKeyPath: "advance")
                results![0].setValue(remains, forKeyPath: "remains")
                results![0].setValue(pickupNumber, forKeyPath: "pickupNumber")
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
    
    func delete(productDetailId:Int) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OrderDetail")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "productDetailId = %d",
                                                 argumentArray: [Double(productDetailId)])
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "OrderDetail")
        
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
