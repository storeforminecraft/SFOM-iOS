//
//  APIEndPoints.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/10.
//

import Foundation

enum APIEndPointError {
    case wrongEndPointError
}

extension APIEndPointError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .wrongEndPointError:
            return NSLocalizedString("wrong EndPoint Error", comment: "wrong EndPoint")
        }
    }
}

// FIXME: - 정리 필요
final class APIEndPoints {
    static let shared = APIEndPoints()
    private init() { }
}

private extension APIEndPoints {
    func checkDocument(doc: String?, docIsUser: Bool?) -> Document? {
        if let doc = doc { return SFOMEndPoint.SFOMDocument.another(doc) }
        if let docIsUser = docIsUser, docIsUser { return SFOMEndPoint.SFOMDocument.currentUser }
        return nil
    }
}

extension APIEndPoints {
    // MARK: - Collection
    func posts() -> SFOMEndPoint? {
        let collection = SFOMEndPoint.SFOMCollection.posts
        return SFOMEndPoint(collection: collection, document: nil)
    }
    
    func eventsTimeline() -> SFOMEndPoint? {
        let collection = SFOMEndPoint.SFOMCollection.events_timeline
        return SFOMEndPoint(collection: collection, document: nil)
    }
    
    func resources(doc: String?) -> SFOMEndPoint? {
        let collection = SFOMEndPoint.SFOMCollection.resources
        let document = checkDocument(doc: doc, docIsUser: false)
        return SFOMEndPoint(collection: collection, document: document)
    }
    
    func playlists(doc: String?) -> SFOMEndPoint? {
        let collection = SFOMEndPoint.SFOMCollection.playlists
        let document = checkDocument(doc: doc, docIsUser: false)
        return SFOMEndPoint(collection: collection, document: document)
    }
    
    func ranksDaily(doc: String?) -> SFOMEndPoint? {
        let collection = SFOMEndPoint.SFOMCollection.ranks_daily
        let document = checkDocument(doc: doc, docIsUser: false)
        return SFOMEndPoint(collection: collection, document: document)
    }
    
    func ranksMonthly(doc: String?) -> SFOMEndPoint? {
        let collection = SFOMEndPoint.SFOMCollection.ranks_monthly
        let document = checkDocument(doc: doc, docIsUser: false)
        return SFOMEndPoint(collection: collection, document: document)
    }
    
    func favorites(doc: String, docIsUser: Bool?) -> SFOMEndPoint? {
        let collection = SFOMEndPoint.SFOMCollection.favorites
        let document = checkDocument(doc: doc, docIsUser: docIsUser)
        return SFOMEndPoint(collection: collection, document: document)
    }
    
    func favoritesResource(doc: String) -> SFOMEndPoint? {
        let collection = SFOMEndPoint.SFOMCollection.favorites_resource
        let document = checkDocument(doc: doc, docIsUser: false)
        return SFOMEndPoint(collection: collection, document: document)
    }
    
    func reports(doc: String?) -> SFOMEndPoint? {
        let collection = SFOMEndPoint.SFOMCollection.reports
        let document = checkDocument(doc: doc, docIsUser: false)
        return SFOMEndPoint(collection: collection, document: document)
    }
    
    //MARK: - SubCollection
    func resourcesComments(doc: String, subDoc: String?) -> SFOMEndPoint? {
        let collection = SFOMEndPoint.SFOMCollection.resources
        guard let document = checkDocument(doc: doc, docIsUser: false) else { return nil }
        let subCollection = SFOMEndPoint.Resources.comments
        let subDocument = checkDocument(doc: subDoc, docIsUser: false)
        return SFOMEndPoint(collection: collection,
                            document: document,
                            subCollection: subCollection,
                            subDocument: subDocument)
    }
    
    func resourcesPlaylist(doc: String, docIsUser: Bool?, subDoc: String?, subDocIsUser: Bool?) -> SFOMEndPoint? {
        let collection = SFOMEndPoint.SFOMCollection.playlists
        guard let document = checkDocument(doc: doc, docIsUser: docIsUser) else { return nil }
        let subCollection = SFOMEndPoint.Playlists.resources_playlist
        let subDocument = checkDocument(doc: subDoc, docIsUser: subDocIsUser)
        return SFOMEndPoint(collection: collection,
                            document: document,
                            subCollection: subCollection,
                            subDocument: subDocument)
    }
    
    func favoritesPlaylist(doc: String, docIsUser: Bool?, subDoc: String?, subDocIsUser: Bool?) -> SFOMEndPoint? {
        let collection = SFOMEndPoint.SFOMCollection.favorites
        guard let document = checkDocument(doc: doc, docIsUser: docIsUser) else { return nil }
        let subCollection = SFOMEndPoint.Favorites.favorites_playlist
        let subDocument = checkDocument(doc: subDoc, docIsUser: subDocIsUser)
        return SFOMEndPoint(collection: collection,
                            document: document,
                            subCollection: subCollection,
                            subDocument: subDocument)
    }
    
    func dailyRankdatas(doc: String, docIsUser: Bool?, subDoc: String?, subDocIsUser: Bool?) -> SFOMEndPoint? {
        let collection = SFOMEndPoint.SFOMCollection.ranks_daily
        guard let document = checkDocument(doc: doc, docIsUser: docIsUser) else { return nil }
        let subCollection = SFOMEndPoint.Ranks_daily.rankdatas
        let subDocument = checkDocument(doc: subDoc, docIsUser: subDocIsUser)
        return SFOMEndPoint(collection: collection,
                            document: document,
                            subCollection: subCollection,
                            subDocument: subDocument)
    }
    
    func monthlyRankdatas(doc: String, docIsUser: Bool?, subDoc: String?, subDocIsUser: Bool?) -> SFOMEndPoint? {
        let collection = SFOMEndPoint.SFOMCollection.ranks_monthly
        guard let document = checkDocument(doc: doc, docIsUser: docIsUser) else { return nil }
        let subCollection = SFOMEndPoint.Ranks_mothly.rankdatas
        let subDocument = checkDocument(doc: subDoc, docIsUser: subDocIsUser)
        return SFOMEndPoint(collection: collection,
                            document: document,
                            subCollection: subCollection,
                            subDocument: subDocument)
    }
}
