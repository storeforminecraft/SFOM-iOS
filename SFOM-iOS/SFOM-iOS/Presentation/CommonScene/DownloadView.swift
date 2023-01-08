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
    // private let documentsURL:
    @Published var remainStorageSizeString: String = "- MB"
    
    
    init(){
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        calcRemainStorageSizeString()
    }
    
    func saveFile(){
        // let directoryURL = documentsURL.appendingPathComponent("ㅇ재ㅜ")
        //
        //
        // do {
        //     // 3-1. 폴더 생성
        //     try fileManager.createDirectory(atPath: directoryURL.path, withIntermediateDirectories: false, attributes: nil)
        // } catch let e {
        //     // 3-2. 오류 처리
        //     print(e.localizedDescription)
        // }
        //
        // // 4. 저장할 파일 이름 (확장자 필수)
        // let helloPath = directoryURL.appendingPathComponent("Hello.txt")
        // // 파일에 들어갈 string
        // let text = "Hello Test Folder"
        //
        // do {
        //     // 4-1. 파일 생성
        //     try text.write(to: helloPath, atomically: false, encoding: .utf8)
        // }catch let error as NSError {
        //     print("Error creating File : \(error.localizedDescription)")
        // }
    }
    
    func calcRemainStorageSizeString() {
        let documentDirectoryPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let attributes = try? FileManager.default.attributesOfFileSystem(forPath: documentDirectoryPath.last! as String)
        guard var freeSize: Double = (attributes?[FileAttributeKey.systemFreeSize] as? NSNumber) as? Double else { return }
        
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
                Text("\(viewModel.remainStorageSizeString) total remaining device")
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
