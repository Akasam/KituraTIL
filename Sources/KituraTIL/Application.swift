//
//  Application.swift
//  CHTTPParser
//
//  Created by Karlo Pagtakhan on 2018-10-17.
//

import CouchDB
import Foundation
import Kitura
import LoggerAPI

public class App {
    
    var client: CouchDBClient?
    var database: Database?
    
    let router = Router()
    
    public func run() {

        postInit()
        Kitura.addHTTPServer(onPort: 8080, with: router)
        Kitura.run()
    }
}


private extension App {
    func postInit() {
        let connectionProperties = ConnectionProperties(host: "database", port: 5984, secured: false, username: "swift_user", password: "harbour7DYESTUFF.malt")
        
        client = CouchDBClient(connectionProperties: connectionProperties)
        
        client!.dbExists("acronyms") { (exists, _) in
            guard exists else {
                self.createNewDatabase()
                return
            }
        }
        
        Log.info("Acronyms database located - loading...")
        
        let database = Database(connProperties: connectionProperties, dbName: "acronyms")
        self.finalizeRoutes(with: database)
    }

    func createNewDatabase() {
        client?.createDB("acronyms", callback: { (database, error) in
            guard let database = database else {
                let errorReason = String(describing: error?.localizedDescription)
                Log.error("Could not create new database: (\(errorReason) - acronym routes not created")
                return
            }
            
            self.finalizeRoutes(with: database)
        })
    }
    
    func finalizeRoutes(with database: Database) {
        self.database = database
        initializeAcronymRoutes(app: self)
        Log.info("Acronym routes created")
    }
}
