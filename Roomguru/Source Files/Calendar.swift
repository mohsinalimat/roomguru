//
//  Calendar.swift
//  Roomguru
//
//  Created by Radoslaw Szeja on 11/03/15.
//  Copyright (c) 2015 Netguru Sp. z o.o. All rights reserved.
//

import UIKit
import SwiftyJSON

class Calendar: ModelObject, NSSecureCoding, Equatable {
    
    private let Summary = "summary"
    private let Identifier = "identifier"
    private let Name = "name"
    
    var accessRole: String?
    var summary:    String?
    var etag:       String?
    var identifier: String?
    var kind:       String?
    var timezone:   String?
    var name:       String?
    
    required init(json: JSON) {
        super.init(json: json)
    }
    
    // MARK: NSSecureCoding
    
    required init(coder aDecoder: NSCoder) {
        super.init()

        func decode(inout variable: String?, forKey key: String) {
            variable = aDecoder.decodeObjectForKey(key) as? String
        }
        
        decode(&summary, forKey: Summary)
        decode(&identifier, forKey: Identifier)
        decode(&name, forKey: Name)
    }

    func encodeWithCoder(aCoder: NSCoder) {
        aCoder.encodeObject(summary, forKey: Summary)
        aCoder.encodeObject(identifier, forKey: Identifier)
        aCoder.encodeObject(name, forKey: Name)
    }
    
    class func supportsSecureCoding() -> Bool {
        return true
    }
    
    // MARK: JSON mapping
    
    class func map(jsonArray: [JSON]?) -> [Calendar]? {
        if let _jsonArray: [JSON] = jsonArray {
            if _jsonArray.isEmpty == true {
                return nil
            }
            return _jsonArray.map { Calendar(json: $0) }
        }
        
        return nil
    }
    
    override func toJSON() -> JSON {
        var json = JSON([])
        json["accessRole"].string = accessRole
        json["etag"].string = etag
        json["id"].string = identifier
        json["kind"].string = kind
        json["summary"].string = summary
        json["timeZone"].string = timezone
        return json
    }
    
    override func map(json: JSON) {
        accessRole = json["accessRole"].string
        etag = json["etag"].string
        identifier = json["id"].string
        kind = json["kind"].string
        summary = json["summary"].string
        timezone = json["timeZone"].string
        name = CalendarPersistenceStore.sharedStore.matchingCalendar(self)?.name
    }
}

// MARK: Equatable

func ==(lhs: Calendar, rhs: Calendar) -> Bool {
    return lhs.identifier == rhs.identifier
}

