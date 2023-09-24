//
//  SourceViewController.swift
//  URL_Test
//
//  Created by Олег Наливайко on 16.09.2023.
//

import UIKit
import WebKit

final class SourceViewController: UIViewController {
    
    //MARK: - Data properties
    let url: String

    //MARK: - UI elements
    private lazy var webView: WKWebView = {
        let webView = WKWebView()
        webView.allowsBackForwardNavigationGestures = true
        return webView
    }()
    private lazy var progressView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.progressViewStyle = .default
        progressView.progressTintColor = .primary
        return progressView
    }()
    private lazy var pullBar: UIView = {
        let pullBar = UIView()
        pullBar.backgroundColor = .white
        pullBar.clipsToBounds = true
        pullBar.layer.cornerRadius = 2.5
        return pullBar
    }()
    
    //MARK: - ViewContreller lifecycle
    init(url: String){
        self.url = url
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        self.url = ""
        super.init(coder: coder)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        
        view.addSubview(progressView)
        progressView.addSubview(pullBar)
        
        view.addSubview(webView)
        makeConstraints()
        
        webView.addObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress), options: .new, context: nil)
        
        CoreDataManager.shared.fetchHTMLData(url: url) { [unowned self] htmlData in
            guard let urlToLoad = URL(string: url) else {return}
            if let htmlData = htmlData {
                DispatchQueue.main.async {
                    self.webView.loadHTMLString(htmlData, baseURL: urlToLoad)
                }
            } else {
                DispatchQueue.main.async {
                    self.webView.load(URLRequest(url: urlToLoad))
                }
            }
        }
        
    }
    deinit {
        webView.removeObserver(self, forKeyPath: #keyPath(WKWebView.estimatedProgress))
    }
        
    //MARK: - Other methods
    private func makeConstraints(){
        progressView.snp.makeConstraints { make in
            make.left.right.equalTo(view)
            make.top.equalTo(view)
            make.height.equalTo(35)
        }
        pullBar.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.width.equalTo(progressView).dividedBy(3)
            make.centerX.centerY.equalTo(progressView)
        }
        webView.snp.makeConstraints { make in
            make.top.equalTo(progressView.snp_bottomMargin)
            make.left.right.bottom.equalTo(view)
        }
    }
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
            if keyPath == "estimatedProgress" {
                progressView.progress = Float(webView.estimatedProgress)
               
            }
        }
}
