//
//  billDescriptionDataQuery.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 22/09/21.
//

import Foundation
import CoreData

struct BillDescriptionQuery {
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
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BillDescription")
        
        //3
        do {
            billDescriptionData = try managedContext.fetch(fetchRequest)
        } catch _ as NSError {
            
        }
        if billDescriptionData.count > 0 {
            let array = FileStoragePath.objShared.convertToJSONArray(moArray: billDescriptionData)
            let lastobject = array[array.count - 1]
            recordBlock(Int(lastobject["billId"] as! Double))
        }
        else {
            recordBlock(-1)
        }
    }
    mutating func saveinDataBase(billId:Int,isPaied:Bool,billImage:Data,customerName:String,customerNumber:String,date:String,amount:Double,billNumber:String) -> Bool {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "BillDescription",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        
        person.setValue(Double(billId), forKeyPath: "billId")
        person.setValue(isPaied, forKeyPath: "isPaied")
        person.setValue(billImage, forKeyPath: "billImage")
        person.setValue(customerName, forKeyPath: "customerName")
        person.setValue(customerNumber, forKeyPath: "customerNumber")
        person.setValue(date, forKeyPath: "date")
        person.setValue(amount, forKeyPath: "amount")
        person.setValue(billNumber, forKeyPath: "billNumber")
        // 4
        do {
            try managedContext.save()
            billDescriptionData.append(person)
            return true
        } catch _ as NSError {
            return false
        }
    }
    
    mutating func fetchAllData(record recordBlock: @escaping (([BillList]) -> Void),failure failureBlock:@escaping ((Bool) -> Void))  {
        var allData = [[String:Any]]()
        var arrBillList = [BillList]()

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
            NSFetchRequest<NSManagedObject>(entityName: "BillDescription")
          //3
          do {
            billDescriptionData = try managedContext.fetch(fetchRequest)
            if billDescriptionData.count > 0 {
                arrBillList.removeAll()
                let array = FileStoragePath.objShared.convertToJSONArray(moArray: billDescriptionData)
                allData = array
                for value in allData {
                    let objCustomer =  BillList(billId: value["billId"] as!Double, isPaied: value["isPaied"] as! Bool, billImage: value["billImage"] as! Data, customerName: value["customerName"] as! String, customerNumber: value["customerNumber"] as! String, date: value["date"] as! String, amount: value["amount"] as!Double,billNumber:value["billNumber"] as! String)
                    arrBillList.append(objCustomer)
                }
                recordBlock(arrBillList)
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
    }
    
    mutating func fetchAllDataByDate(date:String,record recordBlock: @escaping (([BillList]) -> Void),failure failureBlock:@escaping ((Bool) -> Void))  {
        var allData = [[String:Any]]()
        var arrBillList = [BillList]()

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
            NSFetchRequest<NSManagedObject>(entityName: "BillDescription")
            fetchRequest.predicate = NSPredicate(format: "date = %@",
                                                 argumentArray: [date])
          //3
          do {
            billDescriptionData = try managedContext.fetch(fetchRequest)
            if billDescriptionData.count > 0 {
                arrBillList.removeAll()
                let array = FileStoragePath.objShared.convertToJSONArray(moArray: billDescriptionData)
                allData = array
                for value in allData {
                    let objCustomer =  BillList(billId: value["billId"] as!Double, isPaied: value["isPaied"] as! Bool, billImage: value["billImage"] as! Data, customerName: value["customerName"] as! String, customerNumber: value["customerNumber"] as! String, date: value["date"] as! String, amount: value["amount"] as!Double,billNumber:value["billNumber"] as!String)
                    arrBillList.append(objCustomer)
                }
                recordBlock(arrBillList)
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
    }
    
    
    mutating func fetchAllDataByMonth(startDate:String,record recordBlock: @escaping (([BillList]) -> Void),failure failureBlock:@escaping ((Bool) -> Void))  {
        var allData = [[String:Any]]()
        var arrBillList = [BillList]()
          guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
            failureBlock(false)
              return
          }
          
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          //2
          let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "BillDescription")
            fetchRequest.predicate = NSPredicate(format: "date CONTAINS %@",argumentArray: [startDate])
          //3
          do {
            billDescriptionData = try managedContext.fetch(fetchRequest)
            if billDescriptionData.count > 0 {
                arrBillList.removeAll()
                let array = FileStoragePath.objShared.convertToJSONArray(moArray: billDescriptionData)
                allData = array
                for value in allData {
                    let objCustomer =  BillList(billId: value["billId"] as!Double, isPaied: value["isPaied"] as! Bool, billImage: value["billImage"] as! Data, customerName: value["customerName"] as! String, customerNumber: value["customerNumber"] as! String, date: value["date"] as! String, amount: value["amount"] as!Double,billNumber:value["billNumber"] as!String)
                    arrBillList.append(objCustomer)
                }
                recordBlock(arrBillList)
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
    }
    
    
    
    
    func update(billId:Int,isPaied:Bool) -> Bool {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BillDescription")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "billId = %f",
                                                 argumentArray: [Double(billId)])
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                results![0].setValue(isPaied, forKeyPath: "isPaied")
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
    func updateWithBillNumber(billNumber:String,isPaied:Bool) -> Bool {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BillDescription")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "billNumber = %@",
                                                 argumentArray: [billNumber])
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 {
                results![0].setValue(isPaied, forKeyPath: "isPaied")
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
    
    func delete(billId:Int) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BillDescription")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "billId = %.1f",
                                                 argumentArray: [Double(billId)])
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
    
    func deleteEntryWithBillNumber(billNumber:String) -> Bool {
        // Create Fetch Request
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BillDescription")
        fetchRequest.predicate = NSPredicate(format: "billNumber = %@",
                                                 argumentArray: [billNumber])
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(batchDeleteRequest)

        } catch {
            // Error Handling
        }
        return true
    }
    
    func deleteAllEntryFromDB() -> Bool {
        // Create Fetch Request
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BillDescription")
        
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
