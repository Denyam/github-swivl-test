//
//  ImageFetch.swift
//  GithubUsers
//
//  Created by Denis on 06/02/2016.
//  Copyright © 2016 Denis. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class ImageFetch {
	static let instance = ImageFetch()
	
	typealias imageCompletion = (image: UIImage?) -> ()
	
	private init() {}
	
	func getImageForUrl(url: String, completion: imageCompletion) {
		if let downloadedImage = images[url] {
			completion(image: downloadedImage)
		} else if let _ = downloads[url] {
			var completionsList = completions[url]
			if completionsList != nil {
				completionsList!.append(completion)
			} else {
				completions[url] = [completion]
			}
		} else {
			let downloadRequest = Alamofire.request(.GET, url)
			self.downloads[url] = downloadRequest
			downloadRequest.responseImage(completionHandler: { (response: Response<Image, NSError>) in
				let downloadResult = response.result.value
				if let downloadedImage = downloadResult {
					self.images[url] = downloadedImage
				}
				
				completion(image: downloadResult)
				if let additionalCompletions = self.completions[url] {
					for closure in additionalCompletions {
						closure(image: downloadResult)
					}
					
					self.completions.removeValueForKey(url)
				}
				
				self.downloads.removeValueForKey(url)
			})
		}
	}
	
	func cancelDownloadForUrl(url: String) {
		if let downloadRequest = self.downloads[url] {
			downloadRequest.cancel()
			self.downloads.removeValueForKey(url)
			
			self.completions.removeValueForKey(url)
		}
		
	}
	
	private var images = [String: UIImage]()
	private var downloads = [String: Request]()
	private var completions = [String: [imageCompletion]]()
}
