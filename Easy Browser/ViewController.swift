//
//  ViewController.swift
//  Easy Browser
//
//  Created by Boris Nikolaev Borisov on 19/02/2020.
//  Copyright © 2020 Boris Nikolaev Borisov. All rights reserved.
//

import WebKit
import UIKit

class ViewController: UIViewController, WKNavigationDelegate {
    
    var webView: WKWebView!
    var progressView: UIProgressView!
    var selectedURL: String = " "
    
    override func loadView() {
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        edgesForExtendedLayout = []
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "https://\(selectedURL)")!
        webView.load(URLRequest(url: url))
        webView.allowsBackForwardNavigationGestures = true
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Open", style: .plain, target: self, action: #selector(openTapped))
        
        addTopBar()
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
    }
    
    func addTopBar() {
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        progressView = UIProgressView(progressViewStyle: .default)
        progressView.sizeToFit()
        let progressButton = UIBarButtonItem(customView: progressView)
        let refresh = UIBarButtonItem(barButtonSystemItem: .refresh, target: webView, action: #selector(webView.reload))
        let back = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(backTapped))
        let forward = UIBarButtonItem(title: "Forward", style: .plain, target: self, action: #selector(forwardTapped))
        
        toolbarItems = [progressButton, spacer, back, forward, refresh]
        navigationController?.isToolbarHidden = false
    }
    
    @objc func backTapped() {
        if webView.canGoBack {
            webView.goBack()
        }
    }
    
    @objc func forwardTapped() {
        if webView.canGoForward {
            webView.goForward()
        }
    }
    
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        title = webView.title
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "estimatedProgress" {
            progressView.progress = Float(webView.estimatedProgress)
        }
    }
    
    func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        
        let url = navigationAction.request.url
        var websites = [""]
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Table") as? URLTableViewController {
            websites = vc.websites
        }
        
        if let host = url?.host {
            for website in websites {
                if host.contains(website) {
                    decisionHandler(.allow)
                    return
                }
            }
            
            showBlockedURLAlert()
        }
        
        decisionHandler(.cancel)
    }
    
    func showBlockedURLAlert() {
        let ac = UIAlertController(title: "Blocked Host", message: "The URL you are trying to access is forbiden.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Understood", style: .default))
        present(ac, animated: true)
    }
    
    @objc func openTapped() {
        let ac = UIAlertController(title: "Open page...", message: nil, preferredStyle: .actionSheet)
        
        if let vc = storyboard?.instantiateViewController(withIdentifier: "Table") as? URLTableViewController {
            for website in vc.websites {
                ac.addAction(UIAlertAction(title: website, style: .default, handler: openPage))
            }
        }
        
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        ac.popoverPresentationController?.barButtonItem = self.navigationItem.rightBarButtonItem
        present(ac, animated: true)
    }
    
    func openPage(action: UIAlertAction) {
        let url = URL(string: "https://\(action.title!)")!
        webView.load(URLRequest(url: url))
    }
    
}

