//
//  FirestoreEndPoint.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/10.
//

import Foundation

public struct FirestoreEndPoint: FIREndPoint {
    private var collection: MainCollection
    private var document: Document?
    private var subCollection: SubCollection?
    private var subDocument: Document?
    private var subCollection2: SubCollection?
    private var subDocument2: Document?

    init?(collection: MainCollection,
          document: Document?,
          subCollection: (any SubCollection)? = nil,
          subDocument: Document? = nil,
          subCollection2: (any SubCollection)? = nil,
          subDocument2: Document? = nil) {
        guard let collection = collection as? FirestoreEndPoint.SFOMCollection else { return nil }
        if let subCollectionParent = subCollection?.parent {
            guard document != nil else { return nil }
            guard let subCollectionParent = subCollectionParent as? FirestoreEndPoint.SFOMCollection,
                subCollectionParent == collection else { return nil }
        }

        self.collection = collection
        self.document = document
        self.subCollection = subCollection
        self.subDocument = subDocument
        self.subCollection2 = subCollection2
        self.subDocument2 = subDocument2
    }
    
    var reference: (collection: MainCollection,
                    document: Document?,
                    subCollection: SubCollection?,
                    subDocument: Document?,
                    subCollection2: SubCollection?,
                    subDocument2: Document?) {
        return (collection, document, subCollection, subDocument, subCollection2, subDocument2)
    }
}

extension FirestoreEndPoint {
    enum SFOMCollection: String, MainCollection {
        case posts
        case events_timeline
        case ranks_daily
        case ranks_monthly
        case reports
        case resources
        case playlists
        case favorites
        case favorites_resource
        case notice

        var path: String {
            return self.rawValue
        }
    }
    
    enum Resources: String, SubCollection {
        case comments
        var parent: MainCollection { FirestoreEndPoint.SFOMCollection.resources }
        var path: String { self.rawValue }
    }

    enum Favorites: String, SubCollection {
        case favorites_playlist
        var parent: MainCollection { FirestoreEndPoint.SFOMCollection.favorites }
        var path: String { self.rawValue }
    }

    enum Playlists: String, SubCollection {
        case resources_playlist
        var parent: MainCollection { FirestoreEndPoint.SFOMCollection.playlists }
        var path: String { self.rawValue }
    }

    enum Ranks_daily: String, SubCollection {
        case rankdatas
        var parent: MainCollection { FirestoreEndPoint.SFOMCollection.ranks_daily }
        var path: String { self.rawValue }
    }

    enum Ranks_mothly: String, SubCollection {
        case rankdatas = "resourceranks"
        var parent: MainCollection { FirestoreEndPoint.SFOMCollection.ranks_monthly }
        var path: String { self.rawValue }
    }
    
    enum Comments: String, SubCollection {
        case comments
        var parent: MainCollection { FirestoreEndPoint.SFOMCollection.resources }
        var path: String { self.rawValue }
    }

    enum SFOMDocument: Document {
        case currentUser
        case another(_ documentPath: String)
        case combineUser(_ documentPath: String, _ combineString: String, prev: Bool = true)
        
        var needUid: Bool {
            switch self {
            case .currentUser: return true
            case .combineUser: return true
            case .another: return false
            }
        }

        func path(uid: String?) -> String {
            switch self {
            case .currentUser: return "\(uid ?? "")"
            case let .combineUser(doc, combine, prev):
                return prev ? "\(uid ?? "")\(combine)\(doc)" : "\(doc)\(combine)\(uid ?? "")"
            case let .another(path): return path
            }
        }
    }
}
