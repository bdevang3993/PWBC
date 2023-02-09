//
//  BusinessDetail.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 02/09/21.
//

import Foundation
import CoreData
//MARK:- Database Maintains
struct BusinessDatabaseQuerySetUp {
    var people: [NSManagedObject] = []
    mutating func getRecordsCount(record recordBlock: @escaping ((Bool) -> Void) )  {
           //1
              guard let appDelegate =
                UIApplication.shared.delegate as? AppDelegate else {
                recordBlock(false)
                  return
              }
              
              let managedContext =
                appDelegate.persistentContainer.viewContext
              
              //2
              let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "BusinessDetails")
              
              //3
              do {
                people = try managedContext.fetch(fetchRequest)
              
                
              } catch _ as NSError {
               
              }
        if people.count > 0 {
           recordBlock(true)
        }
        else {
           recordBlock(false)
        }
    }
    
    mutating func saveinDataBase(businessName:String,gstInNumber:String,businessType:String,contactNumber:String,emailId:String,password:String,gstCharge:String,busniessAddress:String) -> Bool {
    
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return false
        }
        
        // 1
        let managedContext =
            appDelegate.persistentContainer.viewContext
        
        // 2
        let entity =
            NSEntityDescription.entity(forEntityName: "BusinessDetails",
                                       in: managedContext)!
        
        let person = NSManagedObject(entity: entity,
                                     insertInto: managedContext)
        
       
        person.setValue(businessName, forKeyPath: "businessName")
        person.setValue(busniessAddress, forKey: "busniessAddress")
        person.setValue(businessType, forKeyPath: "businessType")
        person.setValue(contactNumber, forKeyPath: "contactNumber")
        person.setValue(gstInNumber, forKeyPath: "gstInNumber")
        person.setValue(emailId, forKeyPath: "emailId")
        person.setValue(password, forKeyPath: "password")
        person.setValue(gstCharge, forKey: "gstCharge")
        
        // 4
        do {
            try managedContext.save()
            people.append(person)
            return true
        } catch _ as NSError {
            return false
        }
    }
    
    
    mutating func fetchData() -> [String:Any] {
        var dicData = [String:Any]()
          //1
          guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
              return dicData
          }
          
          let managedContext =
            appDelegate.persistentContainer.viewContext
          
          //2
          let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "BusinessDetails")
         // fetchRequest.predicate = NSPredicate(format: "contactNumber = %@",argumentArray:[contactNumber] )

          //3
          do {
            people = try managedContext.fetch(fetchRequest)
            if people.count > 0 {
                let array = FileStoragePath.objShared.convertToJSONArray(moArray: people)//convertToJSONArray(moArray: people)
                dicData = array[0]
            } else {
                return dicData
            }
          } catch _ as NSError {
            return dicData
          }
        return dicData
    }
    
    
    
    func updateDataBase(gstInNumber:String,contactNumber:String,emailId:String,gstCharge:String,busniessAddress:String,businessName:String) -> Bool {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BusinessDetails")
        //var email:String = arrAllData[3].description
        fetchRequest.predicate = NSPredicate(format: "businessName = %@",
                                             argumentArray:[businessName] )
        
        do {
            let results = try context.fetch(fetchRequest) as? [NSManagedObject]
            if results?.count != 0 { // Atleast one was returned
                
                //                // In my case, I only updated the first item in results
                
                results![0].setValue(gstInNumber, forKeyPath: "gstInNumber")
                results![0].setValue(emailId, forKeyPath: "emailId")
                results![0].setValue(gstCharge, forKey: "gstCharge")
                results![0].setValue(busniessAddress, forKey: "busniessAddress")
                results![0].setValue(contactNumber, forKey: "contactNumber")
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
    
    func deleteAllEntryFromDB() -> Bool {
        // Create Fetch Request
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "BusinessDetails")
        
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
