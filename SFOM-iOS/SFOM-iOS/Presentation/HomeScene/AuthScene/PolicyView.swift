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
}

struct PolicyView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var viewModel: PolicyViewModel = PolicyViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            SFOMHeader(title: "",
                       mainTitle: Localized.PolicyView.policyMainTitle,
                       subTitle: Localized.PolicyView.policySubTitle)
            SFOMBackButton {
                dismiss()
            }
            .padding(.top, 5)
            .padding(.bottom, 20)
            VStack (alignment: .center) {
                SFOMCheckButton(content: Localized.PolicyView.agreeAll,
                                check: $viewModel.agreeAll)
                SFOMCheckButton(content: Localized.PolicyView.privacyPolicy,
                                kind: Localized.PolicyView.require,
                                urlString: Localized.Policy.privacyPolicyUrl,
                                check: $viewModel.privacyPolicy)
                SFOMCheckButton(content: Localized.PolicyView.termsOfService,
                                kind: Localized.PolicyView.require,
                                urlString: Localized.Policy.termsOfServiceUrl,
                                check: $viewModel.termsOfService)
                SFOMCheckButton(content: Localized.PolicyView.ageCheck,
                                kind: Localized.PolicyView.require,
                                check: $viewModel.ageCheck)
                SFOMCheckButton(content: Localized.PolicyView.internationalTransferOfPersonalInformation,
                                kind: Localized.PolicyView.require,
                                urlString: Localized.Policy.internationalTransferOfPersonalInformationUrl,
                                check: $viewModel.internationalTransferOfPersonalInformation)
            }
            Spacer()
            VStack (alignment: .center) {
                SFOMNavigationLink(Localized.PolicyView.nextStep) {
                    SignInView()
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

