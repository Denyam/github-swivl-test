//
//  ViewController.swift
//  GithubUsers
//
//  Created by Denis on 05/02/2016.
//  Copyright © 2016 Denis. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {	
	@IBOutlet weak var tableView: UITableView?
	
	private var users = [User]()
	private var loading = false
	
	static private let maxRows = 2000
	
	override func viewDidLoad() {
		super.viewDidLoad()
		
		self.asyncFetchMore()
	}

	override func didReceiveMemoryWarning() {
		super.didReceiveMemoryWarning()
		// Dispose of any resources that can be recreated.
	}

	func numberOfSectionsInTableView(tableView: UITableView) -> Int {
		return 2
	}
	
	func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
		return section == 0 ? min(self.users.count, ViewController.maxRows) : 1
	}
	
	func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
		let cellId = "UserTableViewCell"
		
		let result = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath)
		
		if indexPath.section == 0 {
			result.textLabel?.text = self.users[indexPath.row].login
			result.imageView?.image = nil
			ImageFetch.instance.getImageForUrl(self.users[indexPath.row].avatarUrl) { (image: UIImage?) -> () in
				result.imageView?.image = image
				result.setNeedsLayout()
			}
		}
		
		return result
	}
	
	func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		if indexPath.section == 1 {
			self.asyncFetchMore()
		}
	}
	
	func tableView(tableView: UITableView, didEndDisplayingCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
		ImageFetch.instance.cancelDownloadForUrl(self.users[indexPath.row].avatarUrl)
	}
	
	func asyncFetchMore() {
		if !self.loading {
			self.loading = true
			
			let request = GithubRequest()
			request.perform(since: self.users.count, perPage: 30) { (fetchedUsers: [User]?) -> () in
				self.loading = false
				
				if fetchedUsers != nil {
					self.users.appendContentsOf(fetchedUsers!)
					self.tableView?.reloadData()
				}
			}
		}
	}
}

