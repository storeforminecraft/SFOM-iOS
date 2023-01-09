//
//  DownloadView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/17.
//

import SwiftUI

// FIXME: - fetch DownloadFile & Save File
final class DownloadViewModel: ViewModel {
    private let fileManager = FileManager.default
    private let documentsURL: URL?
    @Published var remainStorageSizeString: String = "- MB"
    @Published var errorMessage: String = ""
    
    
    init(){
        if let documentsURL = fileManager
            .urls(for: .documentDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent("downloads") {
            self.documentsURL = documentsURL
        } else {
            self.documentsURL = nil
            self.errorMessage = "couldn't found documnet URL"
        }
        calcRemainStorageSizeString()
    }
    
    func downloads(resource: Resource){
        guard let destinationURL = documentsURL?.appendingPathComponent("\(resource.id).\(resource.fileExt)") else { return }
        if let downloadURL = resource.downloadURL {
            let urlRequest = URLRequest(url: downloadURL)
            URLSession.shared.downloadTask(with: urlRequest) { fileUrl, urlResponse, error in
             
            }.resume()
        }
    }
    
    func calcRemainStorageSizeString() {
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let attributes = try? FileManager.default.attributesOfFileSystem(forPath: documentDirectoryPath.last! as String)
        guard let freeSize: Double = (attributes?[FileAttributeKey.systemFreeSize] as? NSNumber) as? Double else { return }
        
        let remainByte = freeSize
        let remainKB = remainByte / 1024
        let remainMB = remainKB / 1024
        let remainGB = remainMB / 1024
        
        if remainGB >= 1 {
            remainStorageSizeString = String(format: "%.1fGB", remainGB)
        } else if remainMB  >= 1 {
            remainStorageSizeString  = String(format: "%.1fMB", remainMB)
        } else if remainKB >= 1 {
            remainStorageSizeString =  String(format: "%.1fKB", remainKB)
        } else if remainByte >= 1  {
            remainStorageSizeString = String(format: "%.1fByte", remainByte)
        }
    }
}

struct DownloadView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var viewModel: DownloadViewModel = DownloadViewModel()
    private let resource: Resource
    
    init(resource: Resource) {
        self.resource = resource
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("콘텐츠를 다운로드 하시겠습니까?")
                .font(.SFOMFont14.bold())
            
            VStack (alignment: .leading, spacing: 8) {
                Group {
                    Text("\(resource.localizedName)")
                    // Text("\(viewModel.remainStorageSizeString) total remaining device")
                }
                .font(.SFOMFont12)
                .foregroundColor(Color(.darkGray))
            }
            
            HStack (alignment: .center, spacing: 10){
                SFOMButton("취소",
                           foregroundColor: Color.textPrimaryColor,
                           backgroundColor: Color.searchBarColor,
                           spacer: false,
                           font: .SFOMFont14.bold()) {
                    self.dismiss()
                }
                SFOMButton("다운로드",
                           font: .SFOMFont14.bold()) {
                    self.viewModel.downloads(resource: resource)
                }
            }
            
        }
        .padding(.horizontal, 16)
    }
}

struct DownloadView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadView(resource: TestResource.resource)
    }
}
