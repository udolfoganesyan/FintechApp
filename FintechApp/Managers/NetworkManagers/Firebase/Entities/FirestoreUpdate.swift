//
//  FirestoreUpdate.swift
//  FintechApp
//
//  Created by Rudolf Oganesyan on 03.11.2020.
//  Copyright © 2020 Рудольф О. All rights reserved.
//

import FirebaseFirestore

protocol FirestoreSnapshotInitializable {
    init?(_ document: QueryDocumentSnapshot)
}

struct FirestoreUpdate<Type: FirestoreSnapshotInitializable> {
    
    let added: [Type]
    let modified: [Type]
    let removed: [Type]
    
    init(documentChanges: [DocumentChange]) {
        var added = [Type]()
        var modified = [Type]()
        var removed = [Type]()
        
        for change in documentChanges {
            guard let channel = Type(change.document) else { continue }
            
            switch change.type {
            case .added:
                added.append(channel)
            case .modified:
                modified.append(channel)
            case .removed:
                removed.append(channel)
            }
        }
        
        self.added = added
        self.modified = modified
        self.removed = removed
    }
}
