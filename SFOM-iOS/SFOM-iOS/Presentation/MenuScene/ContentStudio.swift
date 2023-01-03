//
//  ContentStudio.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2023/01/01.
//

import SwiftUI

// FIXME: - Content

struct ContentStudio: View {
    @State private var fileName: String = ""
    @State private var showFileImporter: Bool = false
    var body: some View {
        VStack{
            Text("import file - \(fileName)")
            Button(action: {showFileImporter.toggle()}) {
                Text("show")
            }
        }.fileImporter(isPresented: $showFileImporter, allowedContentTypes: [.zip,.image]) { result in
            do {
            let fileUrl = try result.get()
                self.fileName = fileName
            }catch {
                print(error)
            }
        }
    }
}

struct ContentStudio_Previews: PreviewProvider {
    static var previews: some View {
        ContentStudio()
    }
}
