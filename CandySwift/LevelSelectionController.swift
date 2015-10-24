//
//  LevelSelectionController.swift
//  CandySwift
//
//  Created by Max on 28/07/14.
//  Copyright (c) 2014 MaxHype. All rights reserved.
//

import Foundation
import UIKit
import AVFoundation

class LevelSelectionController: UIViewController
{
	@IBOutlet weak var scrollView: UIScrollView!
	@IBOutlet weak var background: UIImageView!
	@IBOutlet var alertReset: UIView!
	
	var levelsDone: Int!
	
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!)
    {
		if let gameController = segue.destinationViewController as? GameViewController
		{
			let tag = (sender as UIButton).tag
			
			gameController.currentLevelNumber = tag
			
		}
    }
    
    @IBAction func levelSelected(sender: AnyObject)
    {
        self.performSegueWithIdentifier("StartGame", sender: sender)
        
    }
    
    @IBAction func backToMainMenuPressed(sender: AnyObject)
    {
        self.dismissViewControllerAnimated(true)
		{
			
		}		
		
    }
	
	@IBAction func resetLevelsPressed(sender: AnyObject)
	{
		toggleResetAlert()		
	}
	
	@IBAction func okAlertPressed(sender: AnyObject)
	{
		let userDefaults = NSUserDefaults.standardUserDefaults()
		
		userDefaults.setValue(0, forKey:"levelsDone")
		
		userDefaults.synchronize()
		
		toggleResetAlert()
		
		setupLevels()
		
		animateCurrentLevel()
	}
	
	@IBAction func cancelAlertPressed(sender: AnyObject)
	{
		toggleResetAlert()
	}
	
	override func viewDidLoad()
	{
		super.viewDidLoad()
	}
	
	override func viewWillAppear(animated: Bool)
	{
		super.viewWillAppear(animated)
		
		setupLevels()
		
		if (backgroundMusic == nil || backgroundMusic.url != levelSelectionMusicUrl)
		{
			backgroundMusic = AVAudioPlayer(contentsOfURL: levelSelectionMusicUrl, error: nil)
			backgroundMusic.numberOfLoops = -1
			backgroundMusic.play()
		}

	}
	
	override func viewDidAppear(animated: Bool)
	{
		super.viewDidAppear(animated)
		
		animateCurrentLevel()
	}
	
	func toggleResetAlert()
	{
		if self.alertReset.superview != nil
		{
			self.alertReset.alpha = 1
			
			UIView.animateWithDuration(0.3, delay: 0, options: nil,	animations:
			{
				self.alertReset.alpha = 0
				
			},
			completion:
			{	completed in
				if completed
				{
					self.alertReset.removeFromSuperview()
				}
			})
		}
		else
		{
			self.alertReset.frame = self.view.bounds;
			
			UIView.animateWithDuration(0.3, delay: 0, options: nil, animations:
			{
				self.view.addSubview(self.alertReset)
				self.alertReset.alpha = 1
					
			}, completion: nil)
			
		}

	}
	
	func setupLevels()
	{
		scrollView.contentSize = background.bounds.size
		//scrollView.contentOffset = CGPointMake(0, background.bounds.size.height - scrollView.bounds.size.height)
		
		let userDefaults = NSUserDefaults.standardUserDefaults()
		
		levelsDone = userDefaults.valueForKey("levelsDone") as Int!
		
		if levelsDone == nil
		{
			levelsDone = 0
		}
        
        NSLog("levels done is %i", levelsDone)
		
		for view in scrollView.subviews
		{
			if let button:UIButton = view as? UIButton
			{
				if button.tag > levelsDone + 1
				{
					button.hidden = true
				}
				else
				{
					button.hidden = false
					
					if (button.tag != levelsDone + 1)
					{
						button.layer.removeAllAnimations()
						button.transform = CGAffineTransformIdentity
					}
				}
				
				
			}
		}

	}
	
	func animateCurrentLevel()
	{
		if let button = scrollView.viewWithTag(levelsDone + 1)
		{
			UIView.animateWithDuration(0.4, delay: 0, options: UIViewAnimationOptions.Repeat | UIViewAnimationOptions.Autoreverse | UIViewAnimationOptions.AllowUserInteraction, animations:
				{ button.transform = CGAffineTransformMakeScale(0.8, 0.8)}, completion: nil)
			
			scrollView.scrollRectToVisible(CGRectInset(button.frame, -200, -200), animated: true)
		
		}	

	}
	
}
