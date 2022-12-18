//
//  SFOMEndPoint.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/10.
//

import Foundation

public struct SFOMEndPoint: FIREndPoint {
    private var collection: MainCollection
    private var document: Document?
    private var subCollection: SubCollection?
    private var subDocument: Document?

    init?(collection: MainCollection,
          document: Document?,
          subCollection: (any SubCollection)? = nil,
          subDocument: Document? = nil) {
        //FIXME: - 고치기
        guard let collection = collection as? SFOMEndPoint.SFOMCollection else { return nil }
        if let subCollectionParent = subCollection?.parent {
            guard document != nil else { return nil }
            guard let subCollectionParent = subCollectionParent as? SFOMEndPoint.SFOMCollection,
                subCollectionParent == collection else { return nil }
        }

        self.collection = collection
        self.document = document
        self.subCollection = subCollection
        self.subDocument = subDocument
    }
    
    var reference: (collection: MainCollection,
                    document: Document?,
                    subCollection: SubCollection?,
                    subDocument: Document?) {
        return (collection, document, subCollection, subDocument)
    }
}

extension SFOMEndPoint {
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

        var path: String {
            return self.rawValue
        }
    }
    
    enum Resources: String, SubCollection {
        case comments
        var parent: MainCollection { SFOMEndPoint.SFOMCollection.resources }
        var path: String { self.rawValue }
    }

    enum Favorites: String, SubCollection {
        case favorites_playlist
        var parent: MainCollection { SFOMEndPoint.SFOMCollection.favorites }
        var path: String { self.rawValue }
    }

    enum Playlists: String, SubCollection {
        case resources_playlist
        var parent: MainCollection { SFOMEndPoint.SFOMCollection.playlists }
        var path: String { self.rawValue }
    }

    enum Ranks_daily: String, SubCollection {
        case rankdatas
        var parent: MainCollection { SFOMEndPoint.SFOMCollection.ranks_daily }
        var path: String { self.rawValue }
    }

    enum Ranks_mothly: String, SubCollection {
        case rankdatas
        var parent: MainCollection { SFOMEndPoint.SFOMCollection.ranks_monthly }
        var path: String { self.rawValue }
    }

    enum SFOMDocument: Document {
        case currentUser
        case another(_ documentPath: String)

        var isCurrentUser: Bool {
            if case .currentUser = self { return true }
            return false
        }

        var path: String {
            switch self {
            case .currentUser: return ""
            case let .another(path): return path
            }
        }
    }
}
