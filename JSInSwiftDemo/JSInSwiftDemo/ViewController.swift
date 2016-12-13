//
//  ViewController.swift
//  JSInSwiftDemo
//
//  Created by targetcloud on 2016/12/13.
//  Copyright © 2016年 targetcloud. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var webview: UIWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let url = URL(string: "http://c.m.163.com/nc/article/C85G09IV000189FH/full.html")
        let request = URLRequest(url: url!)
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            if(error == nil){
                let jsonData = try? JSONSerialization.jsonObject(with: data!, options: JSONSerialization.ReadingOptions.allowFragments) as! [String:Any]
                self.dealNewsDetail(jsonData!)
            }
        })
        dataTask.resume()
    }

    func dealNewsDetail(_ jsonData: [String:Any])  {
        guard let allData = jsonData["C85G09IV000189FH"] as? [String:Any] else {return}
        var bodyHtml = allData["body"] as! String
        let title = allData["title"] as! String
        let ptime = allData["ptime"] as! String
        let source = allData["source"]  as! String
        let imgArr = allData["img"] as! [[String: Any]]
        for i in 0..<imgArr.count{
            let imgItem = imgArr[i]
            let ref = imgItem["ref"] as! String
            let imgTitle = imgItem["alt"] as! String
            let src = imgItem["src"] as! String
            let imgHtml = "<div class=\"all-img\"><img src=\"\(src)\"><div>\(imgTitle)</div></div>"
            bodyHtml = bodyHtml.replacingOccurrences(of: ref, with: imgHtml)
        }
        let titleHtml = "<div id=\"mainTitle\">\(title)</div>"
        let subTitleHtml = "<div id=\"subTitle\"><span>\(source)</span><span class=\"time\">\(ptime)</span></div>"
        
        let css = Bundle.main.url(forResource: "democss", withExtension: "css")
        let cssHtml = "<link href=\"\(css!)\" rel=\"stylesheet\">"
        
        let js = Bundle.main.url(forResource: "demojs", withExtension: "js")
        let jsHtml = "<script src=\"\(js!)\"></script>"
        
        let html = "<html><head>\(cssHtml)</head><body>\(titleHtml)\(subTitleHtml)\(bodyHtml)\(jsHtml)</body></html>"
        webview.loadHTMLString(html, baseURL: nil)
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        let requestString: NSString = (request.url?.absoluteString)! as NSString
        let range = requestString.range(of: "tg:///")
        let location = range.location
        if(location != NSNotFound){
            let method = requestString.substring(from: range.length)
            let sel = NSSelectorFromString(method)
            self.perform(sel)
        }
        return true
    }
    
    func openCamera() {
        let photoVC = UIImagePickerController()
        photoVC.sourceType = UIImagePickerControllerSourceType.photoLibrary
        self.present(photoVC, animated: true, completion: nil)
    }
}

