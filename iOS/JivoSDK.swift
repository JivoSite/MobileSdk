//
//  JivoSDK.swift
//  JivoSDK
//
//  Created by Roman Mogutnov on 21/02/2018.
//  Copyright © 2018 Mix-Roman. All rights reserved.
//

import ObjectiveC.runtime
import Foundation
import UIKit

protocol JivoDelegate: class {
    /**
     Method will receive the events from the component
     
     - parameter name: Event name
     - parameter data: Data
     
     */
    func onEvent(_ name: String!, _ data: String!)
}

/// JivoSDK+Runtime
final private class MRBarHelper: NSObject {
    @objc var inputAccessoryView: AnyObject? { return nil }
}

/// JivoSDK root class
class JivoSdk: NSObject {
    
    var delegate: JivoDelegate? = nil
    
    fileprivate var webView: UIWebView?
    
    fileprivate var loadingView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
    
    fileprivate var language: String = ""
    
    deinit {
        deregisterForKeyboardNotifications()
    }
}

//MARK: - Internal methods of JivoSDK

extension JivoSdk {
    
    fileprivate func decode(_ encodedString: String) -> String {
        let decodedString = encodedString.removingPercentEncoding
        return decodedString ?? ""
    }
    
}

//MARK: - JivoSDK

extension JivoSdk {
    
    /**
     Init JivoChat
     */
    convenience init(_ web: UIWebView) {
        self.init()
        
        webView = web
        language = ""
    }
    
    /**
     Init JivoChat with language
     */
    convenience init(_ web: UIWebView, _ lang: String) {
        self.init()
        webView = web
        language = lang
    }
    
    /**
     Prepare for starting JivoChat
     
     - important: Make sure you call this method on viewDidLoad()
     
     Setup WebView delegate and subsribe on keyboard notifications
     */
    func prepare() {
        registerForKeyboardNotifications()
        
        webView?.delegate = self
    }
    
    /**
     Start JivoChat
     
     - important: Make sure you set language, WebView and call this method on wWillAppear(_ animated: Bool)
     
     */
    func start() {
        var indexFile = ""
        
        webView?.scrollView.isScrollEnabled = false
        webView?.scrollView.bounces = false
        webView?.scrollView.keyboardDismissMode = .interactive
        
        if language.count > 0 {
            indexFile = "index_\(self.language)"
        } else {
            indexFile = "index"
        }
        
        /// Loading widget in WebView
        let htmlFile = Bundle.main.path(forResource: indexFile, ofType: "html", inDirectory: "/html")
        let htmlString = try! String(contentsOfFile: htmlFile ?? "", encoding: .utf8)
        
        webView?.loadHTMLString(htmlString, baseURL: URL(fileURLWithPath: "\(Bundle.main.bundlePath)/html/"))
    }
    
    /**
     Finishing JivoChat
     
     - important: Make sure you call this method on viewWillDisappear(_ animated: Bool) and deinit
     
     Unsubscribe on keyboard notifications
     */
    func stop() {
        deregisterForKeyboardNotifications()
    }
    
    /**
     Returns the result of running a JavaScript script
     
     */
    func execJs(_ code: String) -> String {
        return webView?.stringByEvaluatingJavaScript(from: code) ?? ""
    }
    
    /**
     Call custom API method with data
     
     */
    func callApiMethod(_ methodName: String, data: String) {
        webView?.stringByEvaluatingJavaScript(from: "window.jivo_api.\(methodName)(\(data));")
    }
}


//MARK: - Loading View

extension JivoSdk {
    
    fileprivate func createLoader() {
        loadingView = UIView(frame: CGRect(x: 0, y: 0, width: 80, height: 80))
        loadingView.backgroundColor = UIColor(white: 0, alpha: 0.6)
        loadingView.layer.cornerRadius = 5
        
        let activityView = UIActivityIndicatorView(activityIndicatorStyle: .white)
        activityView.center = CGPoint(x: loadingView.frame.size.width / 2.0, y: 35)
        activityView.startAnimating()
        activityView.tag = 100
        loadingView.addSubview(activityView)
        
        let labelLoading = UILabel(frame: CGRect(x: 0, y: 48, width: 80, height: 30))
        labelLoading.text = Bundle.main.localizedString(forKey: "Loading", value: "", table: nil)
        labelLoading.textColor = UIColor.white
        labelLoading.font = UIFont(name: labelLoading.font.fontName, size: 15)
        labelLoading.textAlignment = .center
        loadingView.addSubview(labelLoading)
        
        webView?.addSubview(loadingView)
        
        if let center = UIApplication.shared.keyWindow?.center {
            loadingView.center = center
        }
    }
    
    fileprivate func removeLoader() {
        loadingView.removeFromSuperview()
    }
}

//MARK: - UIKeyboardNotifications

extension JivoSdk {
    
    @objc fileprivate func keyboardWillShow(notification: Notification) {
        guard
            let userInfo = notification.userInfo,
            var keyboardFrame = userInfo[UIKeyboardFrameEndUserInfoKey] as? CGRect,
            let webView = webView
        else
        {
            return
        }
        
        keyboardFrame = webView.convert(keyboardFrame, from: nil)
        
        let script = "window.onKeyBoard({visible:true, height:\("\(keyboardFrame.size.height)")}); "
        webView.stringByEvaluatingJavaScript(from: script)
        
    }
    
    @objc fileprivate func keyboardDidShow(notification: Notification) {
        guard
            let notification = notification.userInfo,
            var keyboardFrame = notification[UIKeyboardFrameEndUserInfoKey] as? CGRect,
            let webView = webView
        else
        {
            return
        }
        
        keyboardFrame = webView.convert(keyboardFrame, from: nil)

        _ = execJs("window.scrollTo(0, \("\(String(describing: keyboardFrame.size.height))"));")
    }
    
    @objc fileprivate func keyboardWillHide(notification: Notification) {
        guard var frame = webView?.frame else { return }
        
        frame.origin.y = 0
        
        UIView.animate(withDuration: 0.3, animations: {() -> Void in
            self.webView?.frame = frame
        })
        
        webView?.stringByEvaluatingJavaScript(from: "window.onKeyBoard({visible:false, height:0});")
    }
    
    @objc fileprivate func keyboardDidHide(notification: Notification) {}
    
    fileprivate func registerForKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(notification:)), name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(notification:)), name: .UIKeyboardWillShow, object: nil)
    }
    
    fileprivate func deregisterForKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardWillHide, object: nil)
        NotificationCenter.default.removeObserver(self, name: .UIKeyboardDidHide, object: nil)
    }
}

//MARK: - UIWebViewDelegate

extension JivoSdk: UIWebViewDelegate {
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        createLoader()
        removeInputAccessoryView()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        removeLoader()
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        guard let URL = request.url else { return false }
        
        if URL.scheme?.lowercased() == "jivoapi" {
            let components = URL.absoluteString.replacingOccurrences(of: "jivoapi://", with: "").components(separatedBy: "/")
            let apiKey = components[0] as String
            var data = ""
            if components.count > 1 {
                data = decode((components[1] as String))
            }
            
            delegate?.onEvent(apiKey, data)
            
            return true
        }
        
        return true
    }
    
}

//MARK: - Runtime

extension JivoSdk {
    
    /**
     Remove ToolBar on keyboard
     
     */
    fileprivate func removeInputAccessoryView() {
        guard let webView = webView else { return }
        var targetView: UIView? = nil
        
        for view in webView.scrollView.subviews {
            if String(describing: type(of: view)).hasPrefix("UIWebBrowserView") {
                targetView = view
            }
        }
        
        guard let target = targetView else { return }
        
        let noInputAccessoryViewClassName = "\(target.superclass!)_NoInputAccessoryView"
        var newClass: AnyClass? = NSClassFromString(noInputAccessoryViewClassName)
        if newClass == nil {
            let targetClass: AnyClass = object_getClass(target)!
            newClass = objc_allocateClassPair(targetClass, noInputAccessoryViewClassName.cString(using: String.Encoding.ascii)!, 0)
        }
        
        guard let originalMethod = class_getInstanceMethod(MRBarHelper.self, #selector(getter: MRBarHelper.inputAccessoryView)) else { return }
        
        class_addMethod(newClass!.self, #selector(getter: MRBarHelper.inputAccessoryView), method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod))
        object_setClass(target, newClass!)
    }
}
