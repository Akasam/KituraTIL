//
//  Acronym.swift
//  CHTTPParser
//
//  Created by Karlo Pagtakhan on 2018-10-17.
//

struct Acronym: Codable {
    
    var id: String?
    var short: String
    var long: String
    
    init?(id: String?, short: String, long: String) {
        // 2
        if short.isEmpty || long.isEmpty {
            return nil
        }
        self.id = id
        self.short = short
        self.long = long
    }
}

// 3
extension Acronym: Equatable {
    
    public static func ==(lhs: Acronym, rhs: Acronym) -> Bool {
        return lhs.short == rhs.short && lhs.long == rhs.long
    }
}
