//
//  ViewController.swift
//  uitableview_sample
//
//  Created by Shuhei Kagaya on 2017/06/04.
//  Copyright © 2017 kgyshuhei. All rights reserved.
//

import UIKit

class WebViewController: UIViewController {
    
    @IBOutlet weak var webView: UIWebView!
    
    var link:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let url = URL(string: self.link) {
            let request = URLRequest(url: url)
            self.webView.loadRequest(request)
        }
    }
    
}
