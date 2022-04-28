//
//  Config+CoreDataProperties.swift
//  VBoard
//
//  Created by Gyeongtae Nam on 2022/04/27.
//
//

import Foundation
import CoreData


extension Config {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Config> {
        return NSFetchRequest<Config>(entityName: "Config")
    }

    @NSManaged public var key: String?
    @NSManaged public var value: String?
    
    public var wrappedKey : String {
        key ?? ""
    }
    public var wrappedValue: String {
        value ?? ""
    }

}

extension Config : Identifiable {

}
