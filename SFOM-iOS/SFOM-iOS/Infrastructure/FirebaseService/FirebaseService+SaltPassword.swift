//
//  FirebaseService+SaltPassword.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/10.
//

import Foundation
import Combine
import CryptoKit
import FirebaseDatabase

private extension FirebaseService {
    func saltPassword(email: String, password: String) -> AnyPublisher<String?, Never> {
        guard let emailData = email.data(using: .utf8) else {
            return Just<String?>(nil)
                .eraseToAnyPublisher()
        }
        let child = SHA256.hash(data: emailData).compactMap { String(format: "%02x", $0) }.joined()
        
        return self.reference.child("salts")
            .child(child)
            .getDataPublisher
            .timeout(.seconds(5), scheduler: DispatchQueue.global())
            .catch { _ in Just<DataSnapshot?>(nil).eraseToAnyPublisher() }
            .map { [weak self] dataSnapshot -> String? in
                guard let self = self else { return nil }
                guard let dataSnapshotValue = dataSnapshot?.value else { return nil }
                
                var salt = ""
                if dataSnapshot!.value! is NSNull {
                    guard let sha1Email = self.sha1Hash(data: emailData).lastWord else { return nil }
                    salt = String(sha1Email.prefix(5))
                } else {
                    guard let salt = (dataSnapshotValue as? NSDictionary)?["salt"] as? String else { return nil }
                }
                
                guard let firstHashingData = "MCPE STORE\(password)ver2".data(using: .utf8) else { return nil }
                guard let firstHashing = self.sha1Hash(data: firstHashingData).lastWord else { return nil }
                guard let secondHashingData = "\(salt)\(firstHashing)MCPE_STORE_ver2".data(using: .utf8) else { return nil }
                guard let secondHashing = self.sha2Hash(data: secondHashingData).lastWord else { return }
                return secondHashing
            }
            .eraseToAnyPublisher()
    }
    
    func sha1Hash(data: Data) -> String {
        return Insecure.SHA1.hash(data: data).description
    }
    
    func sha2Hash(data: Data) -> String {
        SHA512.hash(data: data).description
    }
}
