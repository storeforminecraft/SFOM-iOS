//
//  DefaultDownloadTaskDelegate.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2023/01/09.
//

import Foundation

final class DefaultDonwloadTaskDelegate: NSObject, URLSessionDownloadDelegate {
    private var session: URLSession?
    
    override init(){
        super.init()
        let configuration = URLSessionConfiguration.default
        self.session = URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }
    
    func downloadTask(url : URL){
        session?.downloadTask(with: url).resume()
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
    }
}
