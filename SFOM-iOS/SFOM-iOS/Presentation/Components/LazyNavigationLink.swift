//
//  LazyNavigationLink.swift
//  SFOM-iOS
//
//  Created by 이전희 on 2022/12/27.
//

import SwiftUI

struct LazyView<Content>: View where Content: View {
    @ViewBuilder var view:() -> Content
    init(@ViewBuilder _ view: @escaping () -> Content) {
        self.view = view
    }
    var body: Content {
        view()
    }
}

public struct LazyNavigationLink<Label, Destination>: View where Label: View, Destination: View {
    @ViewBuilder var destination:() -> Destination
    @ViewBuilder var label:() -> Label
    
    init(@ViewBuilder destination: @escaping () -> Destination,
         @ViewBuilder label: @escaping () -> Label) {
        self.destination = destination
        self.label = label
    }
    
    public var body: some View {
        NavigationLink {
            LazyView{ destination() }
        } label: {
            label()
        }
    }
}
