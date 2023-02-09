//
//  FileStoragePath.swift
//  ProductWithBillCalculator
//
//  Created by devang bhavsar on 25/10/21.
//

import UIKit
import CoreData

final class FileStoragePath: NSObject {
    static var objShared = FileStoragePath()
    private override init() {
    }
    func setUpDateStorageURl() -> URL {
        let backUpFolderUrl = FileManager.default.urls(for: .applicationSupportDirectory, in:.userDomainMask).first!
        let newString:String = backUpFolderUrl.absoluteString
        let newURL = newString.components(separatedBy: "Devices")
        let setUpURl = URL(string: newURL[0])
        return setUpURl!
    }
    
    func  checkForFileExist() -> Bool {
        let backUpFolderUrl = FileManager.default.urls(for: .applicationSupportDirectory, in:.userDomainMask).first!
        let newString:String = backUpFolderUrl.absoluteString
        let newURL = newString.components(separatedBy: "Devices")
        let setUpURl = URL(string: newURL[0])
        let backupUrl = setUpURl!.appendingPathComponent("selectedDate.txt")
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: backupUrl.path) {
            return true
        } else {
            return false
        }
    }
    
    func backupDatabase(backupName: String){
        let backUpFolderUrl = FileManager.default.urls(for: .documentDirectory, in:.userDomainMask).first!
        let backupUrl = backUpFolderUrl.appendingPathComponent(backupName + ".sqlite")
        let container = NSPersistentContainer(name: kPersistanceStorageName)
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in })

        let store:NSPersistentStore
        store = container.persistentStoreCoordinator.persistentStores.last!
        do {
            try container.persistentStoreCoordinator.migratePersistentStore(store,to: backupUrl,options: nil,withType: NSSQLiteStoreType)
        } catch {
        }
    }
    
    func convertToJSONArray(moArray: [NSManagedObject]) -> [[String:Any]] {
        var jsonArray: [[String: Any]] = []
        for item in moArray {
            var dict: [String: Any] = [:]
            for attribute in item.entity.attributesByName {
                //check if value is present, then add key to dictionary so as to avoid the nil value crash
                if let value = item.value(forKey: attribute.key) {
                    dict[attribute.key] = value
                }
            }
            jsonArray.append(dict)
        }
        return jsonArray
    }
}
