//
//  DetailReportView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2023/01/11.
//

import SwiftUI

final class DetailReportViewModel: ViewModel {
    @Published var reportContent: String = ""
    
    func sendReport(){
        // FIXME: - send Report
    }
}

struct DetailReportView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject private var viewModel: DetailReportViewModel = DetailReportViewModel()
    
    private let report: SFOMReports?
    
    init(report: SFOMReports? = nil){
        self.report = report
    }
    
    var body: some View {
        VStack(spacing: 16) {
            VStack (spacing: 10) {
                Text(StringCollection.Report.reportTitle.localized)
                    .font(.SFOMFont18.bold())
                Text(StringCollection.Report.reportCommentDescription.localized)
                    .font(.SFOMFont14)
                    .foregroundColor(Color(.darkGray))
            }
            
            VStack(alignment: .leading) {
                ZStack(alignment: .topLeading) {
                    TextEditor(text: $viewModel.reportContent)
                        .font(.SFOMFont14)
                        .foregroundColor(.black)
                        .multilineTextAlignment(.leading)
                        .lineLimit(10)
                        .padding(4)
                        .frame(height: 150)
                        .cornerRadius(12)
                        .overlay(RoundedRectangle(cornerRadius: 12)
                            .stroke(Color(.lightGray), lineWidth: 1))
                    
                    Text(viewModel.reportContent == "" ? StringCollection.Report.reportMessageDescription.localized : "")
                        .font(.SFOMFont14)
                        .foregroundColor(Color(.lightGray))
                        .multilineTextAlignment(.leading)
                        .padding(12)
                        .allowsHitTesting(false)
                }
                HStack { Spacer() }
            }
            
            HStack(spacing: 10){
                SFOMButton(StringCollection.Default.back.localized,
                           foregroundColor: Color.textPrimaryColor,
                           backgroundColor: Color.searchBarColor,
                           spacer: true,
                           font: .SFOMFont14.bold()) {
                    self.dismiss()
                }
                
                SFOMButton(StringCollection.Default.confirm.localized,
                           font: .SFOMFont14.bold()) {
                    viewModel.sendReport()
                }
            }
            HStack { Spacer() }
        }
        .padding(.horizontal)
    }
}

struct DetailReportView_Previews: PreviewProvider {
    static var previews: some View {
        DetailReportView()
    }
}
