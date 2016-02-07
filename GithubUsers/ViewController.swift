//
//  ViewController.swift
//  GithubUsers
//
//  Created by Denis on 05/02/2016.
//  Copyright © 2016 Denis. All rights reserved.
//

import UIKit
import Alamofire

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UserTableViewCellDelegate {
	static private let userCellId = "UserTableViewCell"
	static private let progressCellId = "ProgressTableViewCell"
	static private let showAvatarSegueId = "showAvatar"
	
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
		let cellId = indexPath.section == 0 ? ViewController.userCellId : ViewController.progressCellId
		
		let result = tableView.dequeueReusableCellWithIdentifier(cellId, forIndexPath: indexPath)
		if let userCell = result as? UserTableViewCell {
			if indexPath.section == 0 {
				userCell.delegate = self
				userCell.usernameLabel?.text = self.users[indexPath.row].login
				userCell.setProfileLink(self.users[indexPath.row].profileUrl)
				userCell.avatarButton?.setImage(nil, forState: .Normal)
				ImageFetch.instance.getImageForUrl(self.users[indexPath.row].avatarUrl) { (image: UIImage?) -> () in
					userCell.avatarButton?.setImage(image, forState: .Normal)
				}
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
	
	func userTableViewCellShowAvatar(cell: UserTableViewCell) {
		if let avatarImage = cell.avatarButton?.imageForState(.Normal){
			if let avatarVC = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("AvatarViewController") as? AvatarViewController {
				avatarVC.image = avatarImage
				avatarVC.title = cell.usernameLabel?.text
				
				self.presentViewController(avatarVC, animated: true, completion: nil)
			}

		}
	}
}

