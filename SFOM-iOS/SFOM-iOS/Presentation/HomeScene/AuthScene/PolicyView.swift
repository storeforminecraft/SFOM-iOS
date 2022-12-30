//
//  PolicyView.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/21.
//

import SwiftUI
import Combine

final class PolicyViewModel: ObservableObject {
    @Published var disabled: Bool = true
    @Published var agreeAll: Bool = false
    @Published var privacyPolicy: Bool = false
    @Published var termsOfService: Bool = false
    @Published var ageCheck: Bool = false
    @Published var internationalTransferOfPersonalInformation: Bool = false
    private var cancellable = Set<AnyCancellable>()
    private var check: Bool = true
    
    init() {
        bind()
    }
    
    func bind(){
        $agreeAll
            .sink { result in
                if self.check {
                    self.check = false
                    self.privacyPolicy = result
                    self.termsOfService = result
                    self.ageCheck = result
                    self.internationalTransferOfPersonalInformation = result
                } else {
                    self.check = true
                }
            }
            .store(in: &cancellable)
        
        $privacyPolicy
            .combineLatest($termsOfService,
                           $ageCheck,
                           $internationalTransferOfPersonalInformation)
            .map { ![$0.0, $0.1, $0.2, $0.3]
                    .reduce(true) { partialResult, check in
                        partialResult && check
                    }
            }
            .handleEvents(receiveOutput: { result in
                if self.check {
                    self.check = false
                    self.agreeAll = !result
                } else {
                    self.check = true
                }
            })
            .assign(to: \.disabled, on: self)
            .store(in: &cancellable)
    }
    
    deinit{
        cancellable.removeAll()
    }
}

struct PolicyView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var viewModel: PolicyViewModel = PolicyViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            SFOMHeader(title: "",
                       mainTitle: StringCollection.PolicyView.policyMainTitle.localized,
                       subTitle: StringCollection.PolicyView.policySubTitle.localized)
            SFOMBackButton {
                dismiss()
            }
            .padding(.top, 5)
            .padding(.bottom, 20)
            
            VStack (alignment: .center) {
                SFOMCheckButton(content: StringCollection.PolicyView.agreeAll.localized,
                                check: $viewModel.agreeAll)
                SFOMCheckButton(content: StringCollection.PolicyView.privacyPolicy.localized,
                                kind: StringCollection.PolicyView.require.localized,
                                urlString: StringCollection.Policy.privacyPolicyUrl.localized,
                                check: $viewModel.privacyPolicy)
                SFOMCheckButton(content: StringCollection.PolicyView.termsOfService.localized,
                                kind: StringCollection.PolicyView.require.localized,
                                urlString: StringCollection.Policy.termsOfServiceUrl.localized,
                                check: $viewModel.termsOfService)
                SFOMCheckButton(content: StringCollection.PolicyView.ageCheck.localized,
                                kind: StringCollection.PolicyView.require.localized,
                                check: $viewModel.ageCheck)
                SFOMCheckButton(content: StringCollection.PolicyView.internationalTransferOfPersonalInformation.localized,
                                kind: StringCollection.PolicyView.require.localized,
                                urlString: StringCollection.Policy.internationalTransferOfPersonalInformationUrl.localized,
                                check: $viewModel.internationalTransferOfPersonalInformation)
            }
            Spacer()
            VStack (alignment: .center) {
                SFOMNavigationLink(StringCollection.PolicyView.nextStep.localized) {
                    SignUpView()
                }
                .disabled(viewModel.disabled)
            }
            HStack { Spacer() }
        }
        .navigationBarHidden(true)
        .padding(.top, 30)
        .padding(.horizontal, 25)
    }
}

struct PolicyView_Previews: PreviewProvider {
    static var previews: some View {
        PolicyView()
    }
}

