//
//  NetworkEndPoints.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/10.
//

import Foundation

enum NetworkEndPointError {
    case wrongEndPointError
}

extension NetworkEndPointError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .wrongEndPointError:
            return NSLocalizedString("wrong EndPoint Error", comment: "wrong EndPoint")
        }
    }
}

final class NetworkEndPoints {
    static let shared = NetworkEndPoints()
    private init() { }
}

private extension NetworkEndPoints {
    func checkDocument(doc: String?, docIsUser: Bool?) -> Document? {
        if let doc = doc {
            if let docIsUser = docIsUser, docIsUser {
                return FirestoreEndPoint.SFOMDocument.combineUser(doc, "-")
            } else {
                return FirestoreEndPoint.SFOMDocument.another(doc)
            }
        }
        if let docIsUser = docIsUser, docIsUser { return FirestoreEndPoint.SFOMDocument.currentUser }
        return nil
    }
}

extension NetworkEndPoints {
    // MARK: - Collection
    func posts() -> FirestoreEndPoint? {
        let collection = FirestoreEndPoint.SFOMCollection.posts
        return FirestoreEndPoint(collection: collection, document: nil)
    }
    
    func eventsTimeline() -> FirestoreEndPoint? {
        let collection = FirestoreEndPoint.SFOMCollection.events_timeline
        return FirestoreEndPoint(collection: collection, document: nil)
    }
    
    func resources(doc: String? = nil) -> FirestoreEndPoint? {
        let collection = FirestoreEndPoint.SFOMCollection.resources
        let document = checkDocument(doc: doc, docIsUser: false)
        return FirestoreEndPoint(collection: collection, document: document)
    }
    
    func playlists(doc: String? = nil) -> FirestoreEndPoint? {
        let collection = FirestoreEndPoint.SFOMCollection.playlists
        let document = checkDocument(doc: doc, docIsUser: false)
        return FirestoreEndPoint(collection: collection, document: document)
    }
    
    func ranksDaily(doc: String? = nil) -> FirestoreEndPoint? {
        let collection = FirestoreEndPoint.SFOMCollection.ranks_daily
        let document = checkDocument(doc: doc, docIsUser: false)
        return FirestoreEndPoint(collection: collection, document: document)
    }
    
    func ranksMonthly(doc: String? = nil) -> FirestoreEndPoint? {
        let collection = FirestoreEndPoint.SFOMCollection.ranks_monthly
        let document = checkDocument(doc: doc, docIsUser: false)
        return FirestoreEndPoint(collection: collection, document: document)
    }
    
    func favorites(doc: String, docIsUser: Bool? = nil) -> FirestoreEndPoint? {
        let collection = FirestoreEndPoint.SFOMCollection.favorites
        let document = checkDocument(doc: doc, docIsUser: docIsUser)
        return FirestoreEndPoint(collection: collection, document: document)
    }
    
    func favoritesResource(doc: String? = nil) -> FirestoreEndPoint? {
        let collection = FirestoreEndPoint.SFOMCollection.favorites_resource
        let document = checkDocument(doc: doc, docIsUser: true)
        return FirestoreEndPoint(collection: collection, document: document)
    }
    
    func reports(doc: String? = nil) -> FirestoreEndPoint? {
        let collection = FirestoreEndPoint.SFOMCollection.reports
        let document = checkDocument(doc: doc, docIsUser: false)
        return FirestoreEndPoint(collection: collection, document: document)
    }
    
    func notice() -> FirestoreEndPoint? {
        let collection = FirestoreEndPoint.SFOMCollection.notice
        return FirestoreEndPoint(collection: collection, document: nil)
    }
    
    //MARK: - SubCollection
    func resourcesComments(doc: String, subDoc: String? = nil) -> FirestoreEndPoint? {
        let collection = FirestoreEndPoint.SFOMCollection.resources
        guard let document = checkDocument(doc: doc, docIsUser: false) else { return nil }
        let subCollection = FirestoreEndPoint.Resources.comments
        let subDocument = checkDocument(doc: subDoc, docIsUser: false)
        return FirestoreEndPoint(collection: collection,
                            document: document,
                            subCollection: subCollection,
                            subDocument: subDocument)
    }
    
    func resourcesPlaylist(doc: String, docIsUser: Bool? = nil, subDoc: String? = nil, subDocIsUser: Bool? = nil) -> FirestoreEndPoint? {
        let collection = FirestoreEndPoint.SFOMCollection.playlists
        guard let document = checkDocument(doc: doc, docIsUser: docIsUser) else { return nil }
        let subCollection = FirestoreEndPoint.Playlists.resources_playlist
        let subDocument = checkDocument(doc: subDoc, docIsUser: subDocIsUser)
        return FirestoreEndPoint(collection: collection,
                            document: document,
                            subCollection: subCollection,
                            subDocument: subDocument)
    }
    
    func favoritesPlaylist(doc: String, docIsUser: Bool? = nil, subDoc: String? = nil, subDocIsUser: Bool? = nil) -> FirestoreEndPoint? {
        let collection = FirestoreEndPoint.SFOMCollection.favorites
        guard let document = checkDocument(doc: doc, docIsUser: docIsUser) else { return nil }
        let subCollection = FirestoreEndPoint.Favorites.favorites_playlist
        let subDocument = checkDocument(doc: subDoc, docIsUser: subDocIsUser)
        return FirestoreEndPoint(collection: collection,
                            document: document,
                            subCollection: subCollection,
                            subDocument: subDocument)
    }
    
    func dailyRankdatas(doc: String, docIsUser: Bool? = nil, subDoc: String? = nil, subDocIsUser: Bool? = nil) -> FirestoreEndPoint? {
        let collection = FirestoreEndPoint.SFOMCollection.ranks_daily
        guard let document = checkDocument(doc: doc, docIsUser: docIsUser) else { return nil }
        let subCollection = FirestoreEndPoint.Ranks_daily.rankdatas
        let subDocument = checkDocument(doc: subDoc, docIsUser: subDocIsUser)
        return FirestoreEndPoint(collection: collection,
                            document: document,
                            subCollection: subCollection,
                            subDocument: subDocument)
    }
    
    func monthlyRankdatas(doc: String, docIsUser: Bool? = nil, subDoc: String? = nil, subDocIsUser: Bool? = nil) -> FirestoreEndPoint? {
        let collection = FirestoreEndPoint.SFOMCollection.ranks_monthly
        guard let document = checkDocument(doc: doc, docIsUser: docIsUser) else { return nil }
        let subCollection = FirestoreEndPoint.Ranks_mothly.rankdatas
        let subDocument = checkDocument(doc: subDoc, docIsUser: subDocIsUser)
        return FirestoreEndPoint(collection: collection,
                            document: document,
                            subCollection: subCollection,
                            subDocument: subDocument)
    }
    
    func resourcesCommentsChildComment(doc: String, subDoc: String, subDoc2: String? = nil) -> FirestoreEndPoint? {
        let collection = FirestoreEndPoint.SFOMCollection.resources
        guard let document = checkDocument(doc: doc, docIsUser: false) else { return nil }
        let subCollection = FirestoreEndPoint.Resources.comments
        let subDocument = checkDocument(doc: subDoc, docIsUser: false)
        let subCollection2 = FirestoreEndPoint.Comments.comments
        let subDocument2 = checkDocument(doc: subDoc2, docIsUser: false)
        return FirestoreEndPoint(collection: collection,
                            document: document,
                            subCollection: subCollection,
                            subDocument: subDocument,
                            subCollection2: subCollection2,
                            subDocument2: subDocument2)
    }
}
