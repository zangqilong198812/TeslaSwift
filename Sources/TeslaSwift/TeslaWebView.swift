//
//  TeslaWebView.swift
//  TeslaSwift
//
//  Created by zang qilong on 2022/11/13.
//  Copyright © 2022 Joao Nunes. All rights reserved.
//

import SwiftUI

public struct TeslaWebView: UIViewControllerRepresentable {
    let url: URL
    let callback: TeslaLoginCallback
    
    public func makeUIViewController(context: Context) -> TeslaWebLoginViewController {
        return TeslaWebLoginViewController(url: url, callback: callback)
    }
    
    public func updateUIViewController(_ uiViewController: TeslaWebLoginViewController, context: Context) {
        
    }
}
