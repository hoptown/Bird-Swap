//
//  AppDelegate.swift
//  CandySwift
//
//  Created by Max on 28/07/14.
//  Copyright (c) 2014 MaxHype. All rights reserved.
//

import UIKit
import AVFoundation

// Musics
var backgroundMusic: AVAudioPlayer!
var wowMusic: AVAudioPlayer!
var shuffleSound: AVAudioPlayer!

let levelSelectionMusicUrl = NSBundle.mainBundle().URLForResource("LevelSelectionMusic", withExtension: "mp3")
let gameMusicUrl = NSBundle.mainBundle().URLForResource("GameMusic", withExtension: "mp3")
let prettyBirdUrl = NSBundle.mainBundle().URLForResource("PrettyBird", withExtension: "mp3")
let holyMolyUrl = NSBundle.mainBundle().URLForResource("HolyMoly", withExtension: "mp3")
let shuffleUrl = NSBundle.mainBundle().URLForResource("Spray", withExtension: "mp3")


// Social Sharing ///////////////////////////////

let SharingMainMenu = "I'm playing Bird Swap http://appstore.com/birdswap" // http://bit.ly/1A21M4B"
let SharingLevelCompleted = "I just completed Level %d in Bird Swap! http://appstore.com/birdswap" // http://bit.ly/1A21M4B"

//////////////////////////////////////////


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate
{
	var window: UIWindow?

	func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: NSDictionary?) -> Bool
	{
		// Override point for customization after application launch.
        
        /*let userDefaults = NSUserDefaults.standardUserDefaults()
        userDefaults.setBool(false, forKey: "adsPurchased")
        userDefaults.synchronize()*/
        
        
		return true
	}

	func applicationWillResignActive(application: UIApplication) {
	}

	func applicationDidEnterBackground(application: UIApplication) {
	}

	func applicationWillEnterForeground(application: UIApplication) {
	}

	func applicationDidBecomeActive(application: UIApplication)
	{
		
	}

	func applicationWillTerminate(application: UIApplication) {
	}


}

