//
//  GameViewController.swift
//  CandySwift
//
//  Created by Max on 28/07/14.
//  Copyright (c) 2014 MaxHype. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation
import Social

class GameViewController: UIViewController {
	// The scene draws the tiles and cookie sprites, and handles swipes.
	var scene: GameScene!

	// The level contains the tiles, the cookies, and most of the gameplay logic.
	// Needs to be ! because it's not set in init() but in viewDidLoad().
	var level: Level!
		
	var currentLevelNumber : Int!

	var movesLeft: Int = 0
	var score: Int = 0

	@IBOutlet var targetSign: UILabel!
	@IBOutlet var targetLabel: UILabel!
	@IBOutlet var movesSign: UILabel!
	@IBOutlet var movesLabel: UILabel!
	@IBOutlet var scoreSign: UILabel!
	@IBOutlet var scoreLabel: UILabel!
	
	// portrait/landscape ipad views repositioning
	
	@IBOutlet var targetViewPortrait: UIView!
	@IBOutlet var targetViewLandscape: UIView!
	@IBOutlet var movesViewPortrait: UIView!
	@IBOutlet var scoreViewPortrait: UIView!
	@IBOutlet var shuffleViewPortrait: UIView!
	@IBOutlet var movesViewLandscape: UIView!
	@IBOutlet var scoreViewLandscape: UIView!
	@IBOutlet var shuffleViewLandscape: UIView!
	
	@IBOutlet var gameOverView: UIView!
	@IBOutlet var gameOverPanel: UIImageView!
	@IBOutlet var gameOverButtons: UIView!
	@IBOutlet var shuffleButton: UIButton!

	var tapGestureRecognizer: UITapGestureRecognizer!	

	override func prefersStatusBarHidden() -> Bool {
		return true
	}

	override func shouldAutorotate() -> Bool {
		return true
	}

	
	override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		
		if UIDevice.currentDevice().userInterfaceIdiom != .Pad
		{
			return
		}
		
		if UIApplication.sharedApplication().statusBarOrientation == UIInterfaceOrientation.LandscapeLeft || UIApplication.sharedApplication().statusBarOrientation == UIInterfaceOrientation.LandscapeRight
		{
			targetViewLandscape.addSubview(targetSign)
			targetViewLandscape.addSubview(targetLabel)
			
			movesViewLandscape.addSubview(movesSign)
			movesViewLandscape.addSubview(movesLabel)
	
			scoreViewLandscape.addSubview(scoreSign)
			scoreViewLandscape.addSubview(scoreLabel)
	
			shuffleViewLandscape.addSubview(shuffleButton)
			
            //LL
			self.scene.background.size = self.scene.size
			self.scene.background.texture = SKTexture(imageNamed: "Background-Landscape")
		}
		else
		{
			targetViewPortrait.addSubview(targetSign)
			targetViewPortrait.addSubview(targetLabel)
			
			movesViewPortrait.addSubview(movesSign)
			movesViewPortrait.addSubview(movesLabel)
			
			scoreViewPortrait.addSubview(scoreSign)
			scoreViewPortrait.addSubview(scoreLabel)
			
			shuffleViewPortrait.addSubview(shuffleButton)
			
            //LL
			self.scene.background.size = self.scene.size
			self.scene.background.texture = SKTexture(imageNamed: "Background")
		}

	}	
		
	deinit {
		println("GameViewController is being deinitialized")
	}


	override func viewDidLoad() {
		super.viewDidLoad()

		// Configure the view.
		let skView = view as SKView
		skView.multipleTouchEnabled = false

		// Create and configure the scene.
		scene = GameScene(size: skView.bounds.size)
		scene.scaleMode = .ResizeFill

		// Load the level.
		level = Level(filename: "Level_\(currentLevelNumber)")
		scene.level = level
		scene.addTiles()
		scene.swipeHandler = handleSwipe

		// Hide the game over panel from the screen.
		gameOverView.hidden = true
		shuffleButton.hidden = true

		// Present the scene.
		skView.presentScene(scene)

		// Load and start background music.
		backgroundMusic = AVAudioPlayer(contentsOfURL: gameMusicUrl, error: nil)
		backgroundMusic.numberOfLoops = -1
		backgroundMusic.play()

		// Let's start the game!
		beginGame()
	
	}
	
	override func viewWillAppear(animated: Bool)
	{
		
	}
	
	override func viewWillDisappear(animated: Bool)
	{
		
	}

	func beginGame() {
		movesLeft = level.maximumMoves
		score = 0
		updateLabels()

		level.resetComboMultiplier()

		scene.animateBeginGame() {
			self.shuffleButton.hidden = false
		}

		shuffle()
	}

	func shuffle() {
		// Delete the old cookie sprites, but not the tiles.
		scene.removeAllCookieSprites()

		// Fill up the level with new cookies, and create sprites for them.
		let newCookies = level.shuffle()
		scene.addSpritesForCookies(newCookies)
	}

	// This is the swipe handler. MyScene invokes this function whenever it
	// detects that the player performs a swipe.
	func handleSwipe(swap: Swap) {
		// While cookies are being matched and new cookies fall down to fill up
		// the holes, we don't want the player to tap on anything.
		view.userInteractionEnabled = false

		if level.isPossibleSwap(swap) {
			level.performSwap(swap)
			scene.animateSwap(swap, completion: handleMatches)
		} else {
			scene.animateInvalidSwap(swap) {
				self.view.userInteractionEnabled = true
			}
		}
	}

	// This is the main loop that removes any matching cookies and fills up the
	// holes with new cookies. While this happens, the user cannot interact with
	// the app.
	func handleMatches() {
		// Detect if there are any matches left.
		let chains = level.removeMatches()

		// If there are no more matches, then the player gets to move again.
		if chains.count == 0 {
			beginNextTurn()
			return
		}

		// First, remove any matches...
		scene.animateMatchedCookies(chains) {

            // LL
            var flagCount: Int = 0
            
			// Add the new scores to the total.
			for chain in chains {
				self.score += chain.score
                
                // LL
                // sound off when current points > 600
                NSLog("chain score is %d", chain.score)
                if  chain.score > 400 && flagCount == 0 {
                    // Load and start music.
                    wowMusic = AVAudioPlayer(contentsOfURL: holyMolyUrl, error: nil)
                    if !wowMusic.playing {                        
                        wowMusic.numberOfLoops = 1
                        wowMusic.play()
                        flagCount = 1
                    }
                }
			}
			self.updateLabels()

			// ...then shift down any cookies that have a hole below them...
			let columns = self.level.fillHoles()
			self.scene.animateFallingCookies(columns) {

				// ...and finally, add new cookies at the top.
				let columns = self.level.topUpCookies()
				self.scene.animateNewCookies(columns) {

					// Keep repeating this cycle until there are no more matches.
					self.handleMatches()
				}
			}
		}
	}

	func beginNextTurn() {
		level.resetComboMultiplier()
		level.detectPossibleSwaps()
		view.userInteractionEnabled = true
		decrementMoves()
	}

	func updateLabels() {
		targetLabel.text = NSString(format: "%ld", level.targetScore)
		movesLabel.text = NSString(format: "%ld", movesLeft)
		scoreLabel.text = NSString(format: "%ld", score)
	}

	func decrementMoves() {
		--movesLeft
		updateLabels()

		if score >= level.targetScore {
            // LL
            // sound when shuffled
            // Load and start music.
            shuffleSound = AVAudioPlayer(contentsOfURL: prettyBirdUrl, error: nil)
            shuffleSound.numberOfLoops = 1
            shuffleSound.play()
            
            
			gameOverPanel.image = UIImage(named: "LevelComplete")
		gameOverButtons.hidden = false
		saveProgress()
		reportScore()
			showGameOver()
		} else if movesLeft == 0 {
			gameOverPanel.image = UIImage(named: "GameOver")
		gameOverButtons.hidden = true
			showGameOver()
		}
	}
	
	func saveProgress()
	{
	let userDefaults = NSUserDefaults.standardUserDefaults()
	
	var levelsDone = userDefaults.valueForKey("levelsDone") as Int!
	
	if levelsDone == nil
	{
		levelsDone = 0
	}
	
	if currentLevelNumber > levelsDone
	{
		userDefaults.setValue(currentLevelNumber, forKey:"levelsDone")
		
		userDefaults.synchronize()
	}
	
	
	}

	func showGameOver() {
		gameOverView.hidden = false
		scene.userInteractionEnabled = false
		shuffleButton.hidden = true

		scene.animateGameOver(){}
	}

	func hideGameOver() {
	
		gameOverView.hidden = true
		scene.userInteractionEnabled = true

		self.backButtonPressed(self)
	}
	
	
	func reportScore()
	{
		let score = GKScore(leaderboardIdentifier: "Level\(currentLevelNumber)")
		score.value = Int64(self.score);
	
		GKScore.reportScores([score])
			{  (error) -> Void in
				if (error != nil)
				{
					println(error.localizedDescription)
				}
			}
	}

	@IBAction func shuffleButtonPressed(AnyObject) {
        
        // LL
        // sound when shuffled
        // Load and start music.
        shuffleSound = AVAudioPlayer(contentsOfURL: shuffleUrl, error: nil)
        shuffleSound.numberOfLoops = 1
        shuffleSound.play()
        
		shuffle()

		// Pressing the shuffle button costs a move.
		decrementMoves()
	}
		
	@IBAction func backButtonPressed(sender: AnyObject)
	{
		self.dismissViewControllerAnimated(true)
		{
//WARNING: only for test
//			var revMobAdapter = ADS.sharedInstance().use(.RevMob) as? RevMobAdapter
//	
//			if (revMobAdapter != nil)
//			{
//				revMobAdapter!.testMode = true
//			}

			
		}
		
		//Must nil the handler, otherwise Scene retains GameViewController 
		scene.swipeHandler = nil
	}
	
	@IBAction func shareFacebook(sender: AnyObject)
	{
		var socialVC :SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
		
		socialVC.setInitialText(String(format: SharingLevelCompleted, currentLevelNumber))
		
		socialVC.addImage(UIImage(named: "SharingScreenshot"))
		
		self.presentViewController(socialVC, animated: true, completion: nil)
	}
	
	@IBAction func shareTwitter(sender: AnyObject)
	{
		var socialVC :SLComposeViewController = SLComposeViewController(forServiceType: SLServiceTypeTwitter)
		
		socialVC.setInitialText(String(format: SharingLevelCompleted, currentLevelNumber))
		
		socialVC.addImage(UIImage(named: "SharingScreenshot"))
		
		self.presentViewController(socialVC, animated: true, completion: nil)
	}
}
