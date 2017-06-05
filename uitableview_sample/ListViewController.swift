//
//  ViewController.swift
//  uitableview_sample
//
//  Created by Shuhei Kagaya on 2017/06/04.
//  Copyright © 2017 kgyshuhei. All rights reserved.
//

import UIKit

class ListViewController: UITableViewController, XMLParserDelegate {
    
    var parser:XMLParser!
    var items = [Item]()
    var item:Item?
    var currentString = ""
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        cell.textLabel?.text = items[indexPath.row].title
        return cell
    }
	
	// Buttonを拡張する.
	override func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath)
		-> [UITableViewRowAction]? {
		
		// Deleteボタン.
		let myDeleteButton: UITableViewRowAction = UITableViewRowAction(style: .normal, title: "Delete") { (action, index) -> Void in
			
			tableView.isEditing = false
			self.items.remove(at: indexPath.row)
			tableView.deleteRows(at: [indexPath], with: .automatic)
			print("delete")
			
		}
		myDeleteButton.backgroundColor = UIColor.red
		
		return [myDeleteButton]
		
	}
	
	override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
		return true
	}
	
	override func viewDidLoad() {
		super.viewDidLoad()
		startDownload()
	}
	
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    func startDownload() {
        
        self.items = []
	if let url = URL(string: "http://github-trends.ryotarai.info/rss/github_trends_swift_daily.rss") {
			
            if let parser = XMLParser(contentsOf: url) {
                self.parser = parser
                self.parser.delegate = self
                self.parser.parse()
            }
            
        }
        
    }
    
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String]) {
        
        self.currentString = ""
        if elementName == "item" {
            self.item = Item()
        }
        
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        self.currentString += string
    }
    
    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        
        switch elementName {
            case "title": self.item?.title = currentString
            case "link": self.item?.link = currentString
            case "item": self.items.append(self.item!)
            default: break
        }
        
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        self.tableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let indexPath = self.tableView.indexPathForSelectedRow {
            let item = items[indexPath.row]
            let controller = segue.destination as! WebViewController
            controller.title = item.title
            controller.link = item.link
        }
    }
    
}
