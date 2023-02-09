//
//  ProductDetailsQuery.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 06/09/21.
//

import Foundation
import CoreData

struct ProductDetailsQuery {
    var ProductDetailsData: [NSManagedObject] = []
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
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "ProductDetails")
        
        //3
        do {
            ProductDetailsData = try managedContext.fetch(fetchRequest)
        } catch _ as NSError {
            
        }
        if ProductDetailsData.count > 0 {
            let array = FileStoragePath.objShared.convertToJSONArray(moArray: ProductDetailsData)
            let lastobject = array[array.count - 1]
            recordBlock(Int(lastobject["productDetailId"] as! Int64))
        }
        else {
            recordBlock(-1)
        }
    }
    mutating func saveinDataBase(productDetailId:Int,customerId:Int,productId:Int,customerName:String,date:String,iteamName:String,paiedDate:String,price:Double,quantity:String,status:String,numberOfPice:Int) -> Bool {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "ProductDetails",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        person.setValue(Int64(customerId), forKeyPath: "customerId")
        person.setValue(Int64(productDetailId), forKeyPath: "productDetailId")
        person.setValue(Int64(productId), forKeyPath: "productId")
        person.setValue(customerName, forKeyPath: "customerName")
        person.setValue(date, forKeyPath: "date")
        person.setValue(iteamName, forKeyPath: "iteamName")
        person.setValue(paiedDate, forKeyPath: "paiedDate")
        person.setValue(price, forKeyPath: "price")
        person.setValue(quantity, forKeyPath: "quantity")
        person.setValue(status, forKey: "status")
        person.setValue("", forKey: "billNumber")
        person.setValue(Int64(numberOfPice), forKeyPath: "numberOfPice")
        // 4
        do {
            try managedContext.save()
            ProductDetailsData.append(person)
            return true
        } catch _ as NSError {
            return false
        }
    }
    
    mutating func fetchAllData(date:String,name:String,record recordBlock: @escaping (([ProductDetialWithCustomer]) -> Void),failure failureBlock:@escaping ((Bool) -> Void))  {
        var allData = [[String:Any]]()
        var arrProductLists = [ProductDetialWithCustomer]()

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
            NSFetchRequest<NSManagedObject>(entityName: "ProductDetails")
            fetchRequest.predicate = NSPredicate(format: "date = %@ AND customerName = %@",argumentArray:[date,name])
          //3
          do {
            ProductDetailsData = try managedContext.fetch(fetchRequest)
            if ProductDetailsData.count > 0 {
                arrProductLists.removeAll()
                let array = FileStoragePath.objShared.convertToJSONArray(moArray: ProductDetailsData)
                allData = array
                for value in allData {
                    let objCustomer = ProductDetialWithCustomer(productDetailId: Int(value["productDetailId"] as! Int64), customerId: Int(value["customerId"] as! Int64), productId: Int(value["productId"] as! Int64), customerName: value["customerName"] as! String, date: value["date"] as! String, iteamName: value["iteamName"] as! String, paiedDate: value["paiedDate"] as! String, price: value["price"] as! Double, quantity: value["quantity"] as! String, status:value["status"] as! String,billNumber:value["billNumber"] as! String,numberOfPice: value["numberOfPice"] as! Int)
                    arrProductLists.append(objCustomer)
                }
                recordBlock(arrProductLists)
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
    }
    
    mutating func fetchAllDataByName(name:String,record recordBlock: @escaping (([ProductDetialWithCustomer]) -> Void),failure failureBlock:@escaping ((Bool) -> Void))  {
        var allData = [[String:Any]]()
        var arrProductLists = [ProductDetialWithCustomer]()

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
            NSFetchRequest<NSManagedObject>(entityName: "ProductDetails")
            fetchRequest.predicate = NSPredicate(format: "customerName = %@",argumentArray:[name])
          //3
          do {
            ProductDetailsData = try managedContext.fetch(fetchRequest)
            if ProductDetailsData.count > 0 {
                arrProductLists.removeAll()
                let array = FileStoragePath.objShared.convertToJSONArray(moArray: ProductDetailsData)
                allData = array
                for value in allData {
                    let objCustomer = ProductDetialWithCustomer(productDetailId: Int(value["productDetailId"] as! Int64), customerId: Int(value["customerId"] as! Int64), productId: Int(value["productId"] as! Int64), customerName: value["customerName"] as! String, date: value["date"] as! String, iteamName: value["iteamName"] as! String, paiedDate: value["paiedDate"] as! String, price: value["price"] as! Double, quantity: value["quantity"] as! String,status:value["status"] as! String,billNumber:value["billNumber"] as! String)
                    arrProductLists.append(objCustomer)
                }
                recordBlock(arrProductLists)
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
    }
    
    mutating func fetchAllDataByBillNumber(billNumber:String,record recordBlock: @escaping (([ProductDetialWithCustomer]) -> Void),failure failureBlock:@escaping ((Bool) -> Void))  {
        var allData = [[String:Any]]()
        var arrProductLists = [ProductDetialWithCustomer]()

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
            NSFetchRequest<NSManagedObject>(entityName: "ProductDetails")
            fetchRequest.predicate = NSPredicate(format: "billNumber = %@",argumentArray:[billNumber])
          //3
          do {
            ProductDetailsData = try managedContext.fetch(fetchRequest)
            if ProductDetailsData.count > 0 {
                arrProductLists.removeAll()
                let array = FileStoragePath.objShared.convertToJSONArray(moArray: ProductDetailsData)
                allData = array
                for value in allData {
                    let objCustomer = ProductDetialWithCustomer(productDetailId: Int(value["productDetailId"] as! Int64), customerId: Int(value["customerId"] as! Int64), productId: Int(value["productId"] as! Int64), customerName: value["customerName"] as! String, date: value["date"] as! String, iteamName: value["iteamName"] as! String, paiedDate: value["paiedDate"] as! String, price: value["price"] as! Double, quantity: value["quantity"] as! String,status:value["status"] as! String,billNumber:value["billNumber"] as! String)
                    arrProductLists.append(objCustomer)
                }
                recordBlock(arrProductLists)
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
    }
    
    mutating func fetchAllDataByProductId(productDetailId:String,record recordBlock: @escaping (([ProductDetialWithCustomer]) -> Void),failure failureBlock:@escaping ((Bool) -> Void))  {
        var allData = [[String:Any]]()
        var arrProductLists = [ProductDetialWithCustomer]()

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
            NSFetchRequest<NSManagedObject>(entityName: "ProductDetails")
            fetchRequest.predicate = NSPredicate(format: "productDetailId = %@",argumentArray:[productDetailId])
          //3
          do {
            ProductDetailsData = try managedContext.fetch(fetchRequest)
            if ProductDetailsData.count > 0 {
                arrProductLists.removeAll()
                let array = FileStoragePath.objShared.convertToJSONArray(moArray: ProductDetailsData)
                allData = array
                for value in allData {
                    let objCustomer = ProductDetialWithCustomer(productDetailId: Int(value["productDetailId"] as! Int64), customerId: Int(value["customerId"] as! Int64), productId: Int(value["productId"] as! Int64), customerName: value["customerName"] as! String, date: value["date"] as! String, iteamName: value["iteamName"] as! String, paiedDate: value["paiedDate"] as! String, price: value["price"] as! Double, quantity: value["quantity"] as! String,status:value["status"] as! String,billNumber:value["billNumber"] as! String)
                    arrProductLists.append(objCustomer)
                }
                recordBlock(arrProductLists)
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
    }
    
    func update(price:Double,quantity:String,productDetailId:Int,status:String,numberOfPice:Int) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductDetails")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "productDetailId = %d",
                                                 argumentArray: [Int64(productDetailId)])
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                //                // In my case, I only updated the first item in results
                
                results![0].setValue(price, forKeyPath: "price")
                results![0].setValue(quantity, forKeyPath: "quantity")
                results![0].setValue(status, forKey: "status")
                results![0].setValue(Int64(numberOfPice), forKey: "numberOfPice")
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
//    func updateBillNumber(productDetailId:Int,status:String,billNumber:String) -> Bool {
//
//        let appDelegate = UIApplication.shared.delegate as! AppDelegate
//        let context = appDelegate.persistentContainer.viewContext
//        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductDetails")
//        fetchRequest.returnsObjectsAsFaults = false
//        fetchRequest.predicate = NSPredicate(format: "productDetailId = %d",
//                                                 argumentArray: [Int64(productDetailId)])
//
//        do {
//            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
//            if results?.count != 0 { // Atleast one was returned
//
//                //                // In my case, I only updated the first item in results
//
//                results![0].setValue(billNumber, forKeyPath: "billNumber")
//                results![0].setValue(status, forKey: "status")
//            }
//        } catch {
//        }
//
//        do {
//            try context.save()
//            return true
//        }
//        catch {
//            return false
//        }
//    }
    
    func updateWithDate(productDetailId:Int,status:String,date:String,billNumber:String,customerName:String) -> Bool {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductDetails")
        fetchRequest.returnsObjectsAsFaults = false
        fetchRequest.predicate = NSPredicate(format: "productDetailId = %d",
                                                 argumentArray: [Int64(productDetailId)])
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                //                // In my case, I only updated the first item in results
                results![0].setValue(date, forKey: "paiedDate")
                results![0].setValue(status, forKey: "status")
                results![0].setValue(billNumber, forKey: "billNumber")
                results![0].setValue(customerName, forKey: "customerName")
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductDetails")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "productDetailId = %d",
                                                 argumentArray: [Int64(productDetailId)])
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductDetails")
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
    func deleteEntryWithCustomerId(customerId:Int) -> Bool {
        // Create Fetch Request
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductDetails")
        fetchRequest.predicate = NSPredicate(format: "customerId = %d",
                                                 argumentArray: [Int64(customerId)])
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)

        do {
            try context.execute(batchDeleteRequest)

        } catch {
            // Error Handling
        }
        return true
    }
    func deleteAllEntry() -> Bool {
        // Create Fetch Request
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductDetails")
        fetchRequest.predicate = NSPredicate(format: "status = %@",
                                                 argumentArray: [kPaiedStatus])
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductDetails")
        
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
