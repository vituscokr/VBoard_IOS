//
//  ConfigStorage.swift
//  Template
//
//  Created by vitus on 2022/04/22.
//

import Foundation
import CoreData
import Combine
import LSSLibrary

class ConfigStorage : NSObject , ObservableObject {
    
    var items = CurrentValueSubject<[Config], Never>([])
    
    static let shared : ConfigStorage = ConfigStorage()
    private let fetchController : NSFetchedResultsController<Config>
    
    private var viewContext :NSManagedObjectContext {
        return PersistenceController.shared.container.viewContext
    }
    private override init() {

        let fetchRequest: NSFetchRequest<Config> = Config.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "key", ascending: true)]
        
        fetchController = NSFetchedResultsController(
            fetchRequest: fetchRequest,
            managedObjectContext: PersistenceController.shared.container.viewContext,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        super.init()
        
        fetchController.delegate = self
        
        do {
            try fetchController.performFetch()
            items.value = fetchController.fetchedObjects ?? []
        }catch {
            Debug.log("Error : could not fetch objets ")
        }
    }
    func read(key : String ) -> String {
        let objects = fetchController.fetchedObjects?.filter{
            $0.key == key
        }
        guard let object  = objects?.first else {
            return ""
        }
        
        
        return object.wrappedValue
        
    }
    
    func read(key: ConfigKey) -> String {
        return self.read(key: key.rawValue)
    }
    
    func save(key: ConfigKey , value: String) {
        guard !value.isEmpty else {
            return
        }
        
        let objects = fetchController.fetchedObjects?.filter{
            $0.key == key.rawValue
        }
        
        if objects!.count > 0 {
            self.upate(key: key.rawValue, value: value)
        }else {
            self.add(key: key.rawValue, value: value )
        }
        
        
        
    }
    
    func add(key:String, value:String ) {
        let viewContext = fetchController.managedObjectContext
        
        let config = Config(context: viewContext)
        config.key = key
        config.value = value
        do {
            try viewContext.save()
        }catch {
            print(error.localizedDescription)
            
        }
    }
    
    func upate(key: String, value:String)  {
        let viewContext = fetchController.managedObjectContext

        let objects = fetchController.fetchedObjects?.filter{
            $0.key == key
        }
        
        guard let object  = objects?.first else {
            return
        }
        
        object.value = value
        do {
            try viewContext.save()
        }catch {
            print(error.localizedDescription)
            
        }
        
    }
    
    func delete(key:String ) {
        
        let viewContext = fetchController.managedObjectContext

        let objects = fetchController.fetchedObjects?.filter{
            $0.key == key
        }
        guard let array  = objects else {
            return
        }
        for obj in array {
            viewContext.delete(obj)
        }
        do {
            try viewContext.save()
        }catch {
            Debug.log(error.localizedDescription)
        }

        
    }
}


extension ConfigStorage : NSFetchedResultsControllerDelegate {
    public func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        guard let items = controller.fetchedObjects as? [Config] else {
            return
        }
        self.items.value = items
    }
}

