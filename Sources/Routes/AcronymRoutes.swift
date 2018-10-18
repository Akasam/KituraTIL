//
//  AcronymRoutes.swift
//  CHTTPParser
//
//  Created by Karlo Pagtakhan on 2018-10-17.
//

import CouchDB
import Kitura
import KituraContracts
import LoggerAPI

private var database: Database?

func initializeAcronymRoutes(app: App) {
    database = app.database
    app.router.get("/acronyms", handler: getAcronyms)
    app.router.post("/acronyms", handler: addAcronym)
    app.router.delete("/acronyms", handler: deleteAcronym)
}

private func getAcronyms(completion: @escaping ([Acronym]?, RequestError?) -> Void) {
    guard let database = database else { return completion(nil, .internalServerError) }
    
    Acronym.Persistence.getAll(from: database) { acronyms, error in
        return completion(acronyms, error as? RequestError)
    }
}

private func addAcronym(acronym: Acronym, completion: @escaping (Acronym?, RequestError?) -> Void) {
    guard let database = database else { return completion(nil, .internalServerError) }
    
    Acronym.Persistence.save(acronym, to: database) { id, error in
        guard let id = id else { return completion(nil, .notAcceptable) }
        
        Acronym.Persistence.get(from: database, with: id) { newAcronym, error in
            return completion(newAcronym, error as? RequestError)
        }
    }
}

private func deleteAcronym(id: String, completion: @escaping (RequestError?) -> Void) {
    guard let database = database else { return completion(.internalServerError) }
    
    Acronym.Persistence.delete(with: id, from: database) { error in
        return completion(error as? RequestError)
    }
}

