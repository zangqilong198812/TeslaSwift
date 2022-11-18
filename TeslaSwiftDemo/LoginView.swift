//
//  LoginView.swift
//  TeslaSwift
//
//  Created by zang qilong on 2022/11/18.
//  Copyright © 2022 Joao Nunes. All rights reserved.
//

import SwiftUI

struct LoginView: View {
    let api = TeslaSwift(local: .china)
    @State var showLogin = false
    var body: some View {
        Button {
            showLogin = true
        } label: {
            Text("Login")
        }
        .sheet(isPresented: $showLogin) {
            let view = api.authenticateWebView { token in
                debugPrint("token is \(token)")
            }
            view
        }

    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
