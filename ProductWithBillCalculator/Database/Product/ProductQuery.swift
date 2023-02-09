//
//  ProductQuery.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 02/09/21.
//

import Foundation
import CoreData
struct ProductQuery {
    var productData: [NSManagedObject] = []
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
              let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Product")
              
              //3
              do {
                productData = try managedContext.fetch(fetchRequest)
              
                
              } catch _ as NSError {
               
              }
        if productData.count > 0 {
                let array = FileStoragePath.objShared.convertToJSONArray(moArray: productData)
            let lastobject = array[array.count - 1]
            recordBlock(Int(lastobject["productId"] as! Int64))
        }
        else {
            recordBlock(-1)
        }
    }
    mutating func saveinDataBase(productId:Int,iteamName:String,price:Double,qauntityPerUnit:Double,qauntityType:String,qauntity:Double,numberOfPice:Int) -> Bool {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "Product",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
        person.setValue(Int64(productId), forKeyPath: "productId")
        person.setValue(iteamName, forKeyPath: "iteamName")
        person.setValue(price, forKeyPath: "price")
        person.setValue(qauntityPerUnit, forKeyPath: "qauntityPerUnit")
        person.setValue(qauntityType, forKey: "qauntityType")
        person.setValue(qauntity, forKey: "qauntity")
        person.setValue(Int64(numberOfPice), forKey: "numberOfPice")
        // 4
        do {
            try managedContext.save()
            productData.append(person)
            return true
        } catch _ as NSError {
            return false
        }
    }
    
    mutating func fetchDataByItemName(itemName:String,record recordBlock: @escaping (([Items]) -> Void), failure failureBlock:@escaping ((Bool) -> Void))  {
        var allData = [[String:Any]]()
        var arrItems = [Items]()
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
            NSFetchRequest<NSManagedObject>(entityName: "Product")
          fetchRequest.predicate = NSPredicate(format: "iteamName = %@",argumentArray:[itemName])

          //3
          do {
            productData = try managedContext.fetch(fetchRequest)
            if productData.count > 0 {
                arrItems.removeAll()
                let array = FileStoragePath.objShared.convertToJSONArray(moArray: productData)
                allData = array
                for value in allData {
                    let objItem = Items(strItemsName: value["iteamName"] as! String, quantityPerUnit: value["qauntityPerUnit"] as! Double, quantity: value["qauntity"] as! Double, strQuantityType: value["qauntityType"] as! String, price: value["price"] as! Double,productId: Int(value["productId"] as! Int64), numberOfPice:Int(value["numberOfPice"] as! Int64), totalPrice: 0.0)
                    arrItems.append(objItem)
                }
                recordBlock(arrItems)
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
    }
    
    mutating func fetchDataByProdctID(productId:Int,record recordBlock: @escaping (([Items]) -> Void), failure failureBlock:@escaping ((Bool) -> Void))  {
        var allData = [[String:Any]]()
        var arrItems = [Items]()
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
            NSFetchRequest<NSManagedObject>(entityName: "Product")
          fetchRequest.predicate = NSPredicate(format: "productId = %d",argumentArray:[Int64(productId)])

          //3
          do {
            productData = try managedContext.fetch(fetchRequest)
            if productData.count > 0 {
                arrItems.removeAll()
                let array = FileStoragePath.objShared.convertToJSONArray(moArray: productData)
                allData = array
                for value in allData {
                    let objItem = Items(strItemsName: value["iteamName"] as! String, quantityPerUnit: value["qauntityPerUnit"] as! Double, quantity: value["qauntity"] as! Double, strQuantityType: value["qauntityType"] as! String, price: value["price"] as! Double,productId: Int(value["productId"] as! Int64), numberOfPice:Int(value["numberOfPice"] as! Int64), totalPrice: 0.0)
                    arrItems.append(objItem)
                }
                recordBlock(arrItems)
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
    }
    
    
    mutating func fetchAllData(record recordBlock: @escaping (([Items]) -> Void),failure failureBlock:@escaping ((Bool) -> Void))  {
        var allData = [[String:Any]]()
        var arrItems = [Items]()

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
            NSFetchRequest<NSManagedObject>(entityName: "Product")
          //3
          do {
            productData = try managedContext.fetch(fetchRequest)
            if productData.count > 0 {
                arrItems.removeAll()
                let array = FileStoragePath.objShared.convertToJSONArray(moArray: productData)
                allData = array
                for value in allData {
                    let objItem = Items(strItemsName: value["iteamName"] as! String, quantityPerUnit: value["qauntityPerUnit"] as! Double, quantity: value["qauntity"] as! Double, strQuantityType: value["qauntityType"] as! String, price: value["price"] as! Double,productId: Int(value["productId"] as! Int64),numberOfPice:Int(value["numberOfPice"] as! Int64), totalPrice: 0.0)
                    arrItems.append(objItem)
                }
                recordBlock(arrItems)
            } else {
                failureBlock(false)
            }
          } catch _ as NSError {
            failureBlock(false)
          }
    }
    
    func delete(iteamName:String) -> Bool {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "iteamName = %@",
                                                 argumentArray: [iteamName])
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
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Product")
        
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
