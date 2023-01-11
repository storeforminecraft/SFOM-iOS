//
//  DownloadSheet.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/31.
//

import SwiftUI

struct DownloadSheet: UIViewControllerRepresentable {
    private let items: [Any]
    private let applicationActivity: [UIActivity]?
    private let excludedActivityTypes: [UIActivity.ActivityType]?
    
    init(items: [Any],
        applicationActivity: [UIActivity]? = nil,
        excludedActivityTypes: [UIActivity.ActivityType]? = nil) {
        self.items = items
        self.applicationActivity = applicationActivity
        self.excludedActivityTypes = excludedActivityTypes
    }
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let viewController = UIActivityViewController(
            activityItems: items,
            applicationActivities: applicationActivity
        )
        viewController.excludedActivityTypes = excludedActivityTypes
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        
    }
}
