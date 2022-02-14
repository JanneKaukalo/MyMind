//
//  WebView.swift
//  MyMind_testing
//
//  Created by Janne Jussila on 14.2.2022.
//

import SwiftUI
import WebKit

class WebViewDelegate: NSObject, WKNavigationDelegate {
 
    @Binding private var finishedLoading: Bool
    
    init(_ doneLoading: Binding<Bool>) {
        self._finishedLoading = doneLoading
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        guard !webView.isLoading else { return }
        finishedLoading = true
    }
}

struct WebView: UIViewRepresentable {

    private var url: URL
    private var webViewDelegate: WebViewDelegate
    @Binding private var finishedLoading: Bool
    
    init(url: URL, doneLoading: Binding<Bool>) {
        self.url = url
        self._finishedLoading = doneLoading
        self.webViewDelegate = WebViewDelegate(doneLoading)
    }
    
    func makeUIView(context: Context) -> some UIView {
        let webView = WKWebView()
        webView.navigationDelegate = webViewDelegate
        return webView
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        guard let wkWebView = uiView as? WKWebView else { return }
        let request = URLRequest(url: url)
        wkWebView.load(request)
    }
    
    

}
