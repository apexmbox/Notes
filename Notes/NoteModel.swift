//
//  NoteModel.swift
//  Notes
//
//  Created by Apex on 29.07.2021.
//

import Foundation

struct Note: Identifiable {
    let id: Int
    var name: String
    var description: String
    var isFavourite: Bool
    var isInTrash: Bool
    
    private static var idFactory = 0
    
    private static func getUniqueId() -> Int
    {
        idFactory += 1
        return idFactory
    }
    
    init(name: String, description: String, isFavourite: Bool = false, isInTrash: Bool = false) {
        self.id = Note.getUniqueId()
        self.name = name
        self.description = description
        self.isFavourite = isFavourite
        self.isInTrash = isInTrash
    }
}
