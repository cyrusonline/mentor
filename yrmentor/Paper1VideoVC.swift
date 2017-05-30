//
//  Paper1VideoVC.swift
//  yrmentor
//
//  Created by Cyrus Chan on 6/4/2017.
//  Copyright © 2017 ckmobile.com. All rights reserved.
//

import UIKit

class Paper1VideoVC: UIViewController {
    
    var youtube_received:String!

    @IBOutlet weak var webView: UIWebView!

    override func viewDidLoad() {
        super.viewDidLoad()

        webView.allowsInlineMediaPlayback = true
        let youtube = youtube_received!
        webView.frame.size.height = 1
        webView.frame.size = webView.sizeThatFits(CGSize.zero)
        webView.loadHTMLString("<iframe width=\"\(webView.frame.width)\" height=\"\(webView.frame.height)\" src=\"\(youtube)\" frameborder=\"0\" allowfullscreen></iframe>", baseURL: nil)
        
        print(youtube_received)    }

 
    

  

}
