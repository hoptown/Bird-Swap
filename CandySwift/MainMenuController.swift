//
//  MainMenuController.swift
//  CandySwift
//
//  Created by Max on 28/07/14.
//  Copyright (c) 2014 MaxHype. All rights reserved.
//

import Foundation
import Social
import GameKit
import AVFoundation

class MainMenuController: UIViewController, GKGameCenterControllerDelegate
{
	@IBOutlet weak var background: UIImageView!
	
	@IBAction func shareFacebook(sender: AnyObject)
	{
		var socialVC :SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
		
		socialVC.setInitialText(SharingMainMenu)
		
		socialVC.addImage(UIImage(named: "SharingScreenshot"))
		
		self.presentViewController(socialVC, animated: true, completion: nil)
	}
	
	@IBAction func shareTwitter(sender: AnyObject)
	{
		var socialVC :SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
		
		socialVC.setInitialText(SharingMainMenu)
		
		socialVC.addImage(UIImage(named: "SharingScreenshot"))
		
		self.presentViewController(socialVC, animated: true, completion: nil)
	}
	
	@IBAction func showGameCenter(sender: AnyObject)
	{
		let gcViewController = GKGameCenterViewController()
		
		gcViewController.gameCenterDelegate = self
		
		gcViewController.viewState = GKGameCenterViewControllerState.Leaderboards
		
		self.presentViewController(gcViewController, animated: true, completion: nil)
	}
	

	func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!)
	{
		self.dismissViewControllerAnimated(true, completion: nil)
	}
	
	override func viewDidLayoutSubviews()
	{
		super.viewDidLayoutSubviews()
		
		if UIDevice.currentDevice().userInterfaceIdiom != .Pad
		{
			return
		}
		
		if UIApplication.sharedApplication().statusBarOrientation == UIInterfaceOrientation.LandscapeLeft || UIApplication.sharedApplication().statusBarOrientation == UIInterfaceOrientation.LandscapeRight
		{
			background.image = UIImage(named:"Background-Landscape")
		}
		else
		{
			background.image = UIImage(named:"Background")
		}
		
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad()        
		self.authenticateLocalPlayer()
		
	}
	
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    
	override func viewWillAppear(animated: Bool)
	{
		super.viewWillAppear(animated)
		
        backgroundMusic = AVAudioPlayer(contentsOfURL: prettyBirdUrl, error: nil)
        backgroundMusic.numberOfLoops = 1
        backgroundMusic.play()
        
		if (backgroundMusic != nil)
		{
			//backgroundMusic.stop()
            
            
            
			//backgroundMusic = nil
		}
		
	}
    
    override func viewWillDisappear(animated: Bool) {
    }
	
	func authenticateLocalPlayer()
	{
		var localPlayer = getLocalPlayer() //must call ObjC function cause Apple bug in Swift localplayer, see: http://stackoverflow.com/questions/24045244/game-center-not-authenticating-using-swift
		
		localPlayer.authenticateHandler = {(viewController, error) -> Void in
			if (viewController != nil)
			{
				self.presentViewController(viewController, animated: true, completion: nil)
			}
			else
			{
				println((localPlayer.authenticated))
			}
		}
	}
	
}