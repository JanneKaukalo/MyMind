//
//  WebView.swift
//  MyMind_testing
//
//  Created by Janne Jussila on 14.2.2022.
//

import SwiftUI
import WebKit

class WebViewDelegate: NSObject, WKNavigationDelegate {
 
    @Binding private var showActivityIndicator: Bool
    
    init(_ showActivityIndicator: Binding<Bool>) {
        self._showActivityIndicator = showActivityIndicator
    }
    
    // use this if want to show activityIndicator until whole view has been loaded
//    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
//        guard !webView.isLoading else { return }
//        finishedLoading = true
//    }
    
    // hiding activity indicator immediately when web view start to show
    // not perfect timing but way better than above
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        showActivityIndicator = false
    }
    
}

struct WebView: UIViewRepresentable {

    private var url: URL
    private var webViewDelegate: WebViewDelegate
    
    init(url: URL, showActivityIndicator: Binding<Bool>) {
        self.url = url
        self.webViewDelegate = WebViewDelegate(showActivityIndicator)
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
