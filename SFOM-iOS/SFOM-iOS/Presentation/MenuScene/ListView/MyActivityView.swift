//
//  MyCommentsView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/20.
//

import SwiftUI

// MARK: - Get User's Comments & sort
struct MyActivityView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack{
            
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button{
                    dismiss()
                } label: {
                    HStack(alignment: .center,spacing: 2){
                        Group {
                            Image(systemName: "chevron.backward")
                                .font(.SFOMFont16.bold())
                            Text("")
                                .font(.SFOMMediumFont.bold())
                        }
                        .foregroundColor(.black)
                    }
                }
            }
        }
    }
}

struct MyCommentsView_Previews: PreviewProvider {
    static var previews: some View {
        MyActivityView()
    }
}
