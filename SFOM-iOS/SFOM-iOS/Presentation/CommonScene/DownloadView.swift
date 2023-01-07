//
//  DownloadView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/17.
//

import SwiftUI

// FIXME: - fetch DownloadFile & Save File
final class DownloadViewModel: ObservableObject {
    private let fileManager = FileManager.default
    // private let documentsURL:
   
    
    init(){
        // private let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
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
}

struct DownloadView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            Button {
                dismiss()
            } label: {
                Text("Dismiss")
            }
            Text("Hellow")
        }
    }
}

struct DownloadView_Previews: PreviewProvider {
    static var previews: some View {
        DownloadView()
    }
}
