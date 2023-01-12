//
//  ReportView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2023/01/11.
//

import SwiftUI

struct ReportView: View {
    @Environment(\.dismiss) var dismiss
    private let reportContent: [SFOMReports] = SFOMReports.list
    
    private let targetPath: String
    private let isComment: Bool
    @State var selected: Int = 0
    
    @State private var showDetailReport: Bool = false
    
    init(_ targetPath: String, isComment: Bool = false, selected: Int = 0){
        self.targetPath = targetPath
        self.isComment = isComment
        self.selected = selected
    }
    
    var body: some View {
        VStack(spacing: 16) {
            VStack (spacing: 10) {
                if !isComment {
                    Text(StringCollection.Report.reportTitle.localized)
                        .font(.SFOMFont18.bold())
                    Text(StringCollection.Report.reportDescription.localized)
                        .font(.SFOMFont14)
                        .foregroundColor(Color(.darkGray))
                } else {
                    Text(StringCollection.Report.reportTitle.localized)
                        .font(.SFOMFont18.bold())
                    Text(StringCollection.Report.reportCommentDescription.localized)
                        .font(.SFOMFont14)
                        .foregroundColor(Color(.darkGray))
                }
                
                Text(targetPath)
            }
            
            VStack(alignment: .leading) {
                RadioBox($selected, contentList: reportContent.map { $0.description })
                HStack { Spacer() }
            }
            
            HStack(spacing: 10){
                SFOMButton(StringCollection.Default.cancel.localized,
                           foregroundColor: Color.textPrimaryColor,
                           backgroundColor: Color.searchBarColor,
                           spacer: true,
                           font: .SFOMFont14.bold()) {
                    self.dismiss()
                }
                
                SFOMButton(StringCollection.Default.confirm.localized,
                           font: .SFOMFont14.bold()) {
                    self.showDetailReport.toggle()
                }
            }
            HStack { Spacer() }
        }
        .padding(.horizontal)
        .sheet(isPresented: $showDetailReport) {
            DetailReportView()
        }
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView("", isComment: false)
    }
}
