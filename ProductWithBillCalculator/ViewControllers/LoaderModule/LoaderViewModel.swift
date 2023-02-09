//
//  LoaderViewModel.swift
//  PersonEconomy
//
//  Created by devang bhavsar on 18/09/21.
//

import UIKit
import CoreData
class LoaderViewModel: NSObject {
    var viewController:UIViewController?
    func destroyPersistentStore() {
        let storeFolderUrl = FileManager.default.urls(for: .applicationSupportDirectory, in:.userDomainMask).first!
        let storeUrl = storeFolderUrl.appendingPathComponent("\(kProductDataBase).sqlite")
        let filerManager = FileManager.default
        do{
           try filerManager.removeItem(at: storeUrl)
            self.destoryLocalFolder()
        } catch {
        }
    }
    
    func destoryLocalFolder() {
        let backUpFolderUrl = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!
        let backupUrl = backUpFolderUrl.appendingPathComponent(kProductDataBase + ".sqlite")
        let filerManager1 = FileManager.default
        do{
           try filerManager1.removeItem(at: backupUrl)
        } catch {
        }
        let container = NSPersistentContainer(name: kPersistanceStorageName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            let stores = container.persistentStoreCoordinator.persistentStores
            let filerManager2 = FileManager.default
            do{
                try filerManager2.removeItem(at: stores[0].url!)
            } catch {
            }
        })
       
    }
    func moveToMainPage() {
        DispatchQueue.main.async {
            let initialViewController = UIStoryboard(name: MainStoryBoard, bundle: nil).instantiateViewController(withIdentifier: "LoginNavigation")
            self.viewController!.view.window?.rootViewController = initialViewController
        }
    }
    
    func deleteAllEntry() {
        let userdefault = UserDefaults.standard
        let email = userdefault.value(forKey: kEmail)
        let password = userdefault.value(forKey: kPassword)
        if email != nil {
            KeychainService.deleteEmail(email: email as! NSString)
            KeychainService.deletePassword(password: password as! NSString)
        }
        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()
        print(Array(UserDefaults.standard.dictionaryRepresentation().keys).count)
        DispatchQueue.main.asyncAfter(deadline: .now() + 1)  {
       let objPayerDetailsQuery =  PayerDetailsQuery()
        if objPayerDetailsQuery.deleteAllEntryFromDB() {

        }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 3)  {
            let objOrderDetailsQuery = OrderDetailsQuery()
            if objOrderDetailsQuery.deleteAllEntryFromDB() {
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5)  {
            let objBillDescriptionQuery = BillDescriptionQuery()
            if objBillDescriptionQuery.deleteAllEntryFromDB() {
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 7)  {
            let objBusinessDatabaseQuerySetUp = BusinessDatabaseQuerySetUp()
            if objBusinessDatabaseQuerySetUp.deleteAllEntryFromDB() {
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 9)  {
            let objProductQuery = ProductQuery()
            if objProductQuery.deleteAllEntryFromDB() {
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 11)  {
            let objCustomerQuery = CustomerQuery()
            if objCustomerQuery.deleteAllEntryFromDB() {
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 13)  {
            let objProductDetailsQuery = ProductDetailsQuery()
            if objProductDetailsQuery.deleteAllEntryFromDB() {
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 15)  {
            let objLicenceDetailsQuery = LicenceDetailsQuery()
            if objLicenceDetailsQuery.deleteAllEntryFromDB() {
                self.backup(backupName: kProductDataBase)
                self.moveToMainPage()
            }
        }
    }
    
    func backup(backupName: String){
        let backUpFolderUrl = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!
        let backupUrl = backUpFolderUrl.appendingPathComponent(backupName + ".sqlite")
        let container = NSPersistentContainer(name: kPersistanceStorageName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in })
        let store:NSPersistentStore
        if container.persistentStoreCoordinator.persistentStores.last != nil {
            store = container.persistentStoreCoordinator.persistentStores.last!
            do {
                try container.persistentStoreCoordinator.migratePersistentStore(store,to: backupUrl,options: nil,withType: NSSQLiteStoreType)
               
            } catch {
            }
        }
    }

    
    func restoreFromStore(backupName: String){
            let storeFolderUrl = FileManager.default.urls(for: .applicationSupportDirectory, in:.userDomainMask).first!
            let storeUrl = storeFolderUrl.appendingPathComponent("\(backupName).sqlite")
            let backUpFolderUrl = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!
            let backupUrl = backUpFolderUrl.appendingPathComponent(backupName + ".sqlite")

            let container = NSPersistentContainer(name: kPersistanceStorageName)
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                let stores = container.persistentStoreCoordinator.persistentStores
                for _ in stores {
                    isDataBaseAvailable = true
                }
                do{
                    try container.persistentStoreCoordinator.replacePersistentStore(at: storeUrl,destinationOptions: nil,withPersistentStoreFrom: backupUrl,sourceOptions: nil,ofType: NSSQLiteStoreType)
                    self.moveToHomePage()
                } catch {
                    self.moveToHomePage()
                }
            })
        }
    
    func moveToHomePage() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: MainStoryBoard, bundle: nil)
            let initialViewController = storyboard.instantiateViewController(withIdentifier: "SWRevealViewController") as! SWRevealViewController
            self.viewController!.view.window?.rootViewController = initialViewController
        }
    }
}
