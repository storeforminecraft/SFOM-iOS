//
//  SFOMSecure.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/01.
//

import CryptoKit
import Foundation

struct SFOMSecure {

    static func SaltPassword(email: String, password: String, completion: @escaping (_ saltPassword: String) -> Void) {
        guard let data = email.data(using: .utf8) else { return }

        let child = SHA256.hash(data: data).compactMap { String(format: "%02x", $0) }.joined()

        FirebaseService.shared.ref.child("salts").child(child).getData { error, dataSnapshot in
            if let error = error {
                print(error)
                return
            }

            var salt = ""

            if dataSnapshot!.value! is NSNull {
                guard let emailData = email.data(using: .utf8) else { return }
                guard let sha1Email = Insecure.SHA1.hash(data: emailData).description.components(separatedBy: [" "]).last else { return }
                salt = String(sha1Email.prefix(5))

            } else {
                salt = (dataSnapshot!.value! as! NSDictionary)["salt"] as! String
            }

            let firstHashingData = "MCPE STORE\(password)ver2".data(using: .utf8)!
            guard let firstHashing = Insecure.SHA1.hash(data: firstHashingData).description.components(separatedBy: [" "]).last else { return }

            let secondHashingData = "\(salt)\(firstHashing)MCPE_STORE_ver2".data(using: .utf8)!
            guard let secondHashing = SHA512.hash(data: secondHashingData).description.components(separatedBy: [" "]).last else { return }

            completion(secondHashing)
        }
    }
}
