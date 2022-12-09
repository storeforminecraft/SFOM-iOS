//
//  APIEndPoints.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/10.
//

import Foundation

final class SFOMAPIEndPoints {
    static let shared = SFOMAPIEndPoints()
    private init() { }
}

private extension SFOMAPIEndPoints {
    func checkDocument(doc: String?, docIsUser: Bool?) -> Document? {
        if let doc = doc { return SFOMEndPoint.SFOMDocument.another(doc) }
        if let docIsUser = docIsUser, docIsUser { return SFOMEndPoint.SFOMDocument.currentUser }
        return nil
    }
}

extension SFOMAPIEndPoints {
    // MARK: - Collection
    func posts(doc: String?, docIsUser: Bool?) -> SFOMEndPoint? {
        let collection = SFOMEndPoint.SFOMCollection.posts
        let document = checkDocument(doc: doc, docIsUser: docIsUser)
        return SFOMEndPoint(collection: collection, document: document)
    }

    func resources(doc: String, docIsUser: Bool?) -> SFOMEndPoint? {
        let collection = SFOMEndPoint.SFOMCollection.resources
        let document = checkDocument(doc: doc, docIsUser: docIsUser)
        return SFOMEndPoint(collection: collection, document: document)
    }

    func playlists(doc: String, docIsUser: Bool?) -> SFOMEndPoint? {
        let collection = SFOMEndPoint.SFOMCollection.playlists
        let document = checkDocument(doc: doc, docIsUser: docIsUser)
        return SFOMEndPoint(collection: collection, document: document)
    }

    func ranksDaily(doc: String?, docIsUser: Bool?) -> SFOMEndPoint? {
        let collection = SFOMEndPoint.SFOMCollection.ranks_daily
        let document = checkDocument(doc: doc, docIsUser: docIsUser)
        return SFOMEndPoint(collection: collection, document: document)
    }

    func ranksMonthly(doc: String?, docIsUser: Bool?) -> SFOMEndPoint? {
        let collection = SFOMEndPoint.SFOMCollection.ranks_monthly
        let document = checkDocument(doc: doc, docIsUser: docIsUser)
        return SFOMEndPoint(collection: collection, document: document)
    }

    func favorites(doc: String, docIsUser: Bool?) -> SFOMEndPoint? {
        let collection = SFOMEndPoint.SFOMCollection.favorites
        let document = checkDocument(doc: doc, docIsUser: docIsUser)
        return SFOMEndPoint(collection: collection, document: document)
    }

    func favoritesResource(doc: String, docIsUser: Bool?) -> SFOMEndPoint? {
        let collection = SFOMEndPoint.SFOMCollection.favorites_resource
        let document = checkDocument(doc: doc, docIsUser: docIsUser)
        return SFOMEndPoint(collection: collection, document: document)
    }

    func reports(doc: String?, docIsUser: Bool?) -> SFOMEndPoint? {
        let collection = SFOMEndPoint.SFOMCollection.reports
        let document = checkDocument(doc: doc, docIsUser: docIsUser)
        return SFOMEndPoint(collection: collection, document: document)
    }

    //MARK: - SubCollection
    func resourcesPlaylist(doc: String?, docIsUser: Bool?, subDoc: String?, subDocIsUser: Bool?) -> SFOMEndPoint? {
        let collection = SFOMEndPoint.SFOMCollection.playlists
        guard let document = checkDocument(doc: doc, docIsUser: docIsUser) else { return nil }
        let subCollection = SFOMEndPoint.Playlists.resources_playlist
        let subDocument = checkDocument(doc: subDoc, docIsUser: subDocIsUser)
        return SFOMEndPoint(collection: collection,
                            document: document,
                            subCollection: subCollection,
                            subDocument: subDocument)
    }

    func favoritesPlaylist(doc: String?, docIsUser: Bool?, subDoc: String?, subDocIsUser: Bool?) -> SFOMEndPoint? {
        let collection = SFOMEndPoint.SFOMCollection.favorites
        guard let document = checkDocument(doc: doc, docIsUser: docIsUser) else { return nil }
        let subCollection = SFOMEndPoint.Favorites.favorites_playlist
        let subDocument = checkDocument(doc: subDoc, docIsUser: subDocIsUser)
        return SFOMEndPoint(collection: collection,
                            document: document,
                            subCollection: subCollection,
                            subDocument: subDocument)
    }

    func dailyRankdatas(doc: String?, docIsUser: Bool?, subDoc: String?, subDocIsUser: Bool?) -> SFOMEndPoint? {
        let collection = SFOMEndPoint.SFOMCollection.ranks_daily
        guard let document = checkDocument(doc: doc, docIsUser: docIsUser) else { return nil }
        let subCollection = SFOMEndPoint.Ranks_daily.rankdatas
        let subDocument = checkDocument(doc: subDoc, docIsUser: subDocIsUser)
        return SFOMEndPoint(collection: collection,
                            document: document,
                            subCollection: subCollection,
                            subDocument: subDocument)
    }

    func monthlyRankdatas(doc: String?, docIsUser: Bool?, subDoc: String?, subDocIsUser: Bool?) -> SFOMEndPoint? {
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
