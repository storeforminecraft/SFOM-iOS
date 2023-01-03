//
//  DownloadListView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/27.
//

import SwiftUI

// FIXME: DownloadList
final class DownloadListViewModel: ViewModel {
    func fetchDonwloadList() {}
}

struct DownloadListView: View {
    @ObservedObject private var viewModel: DownloadViewModel = DownloadViewModel()
    @State var showDownloadFileShare: Bool = false
    @State var show: Bool = false
    
    var body: some View {
        VStack {
           
        }
        .sheet(isPresented: $showDownloadFileShare) {
            DownloadSheet(items: ["dddddddddd"])
        }
    }
}

// struct DownloadListView_Previews: PreviewProvider {
//     static var previews: some View {
//         // DownloadListView()
//     }
// }
