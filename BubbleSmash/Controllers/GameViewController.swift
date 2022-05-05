//
//  GameViewController.swift
//  BubbleSmash
//
//  Created by Zach Clare on 26/4/2022.
//

import UIKit

class GameViewController: UIViewController {
    @IBOutlet weak var remainingTimeLabel: UILabel!
    @IBOutlet weak var gameAreaView: UIView!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var highscoreLabel: UILabel!
    @IBOutlet weak var backButton: UINavigationItem!
    
    var name: String = ""
    var score: Int = 0
    var remainingTime: Int = 60 // Set some default values
    var amountOfBubbles: Int = 15 // another one here
    var timer = Timer()
    var countdown = Timer()
    var bubbles: [Bubble] = []
    var previousBubble: Int = 0 // used to track the bubble combo
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Setup the top labels
        scoreLabel.text = String(score)
        remainingTimeLabel.text = String(remainingTime)
        highscoreLabel.text = "\(UDM.shared.getHighScore())"
        
        // show a 3 second countdown
        showCountdown()
        
        // wait for the countdown to go away
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // activate the timer, removing and generating bubbles every second
            self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {
                timer in
                self.removeBubbles()
                self.generateBubbles()
                self.counting()
            }
        }
    }
    
    // shows a 3 second countdown before the game starts
    func showCountdown() {
        var count = 3
        
        // greyed out background
        let background = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        background.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
    
        // number text on the background
        let label = UILabel(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height))
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 120)
        label.textAlignment = .center
        label.text = "\(count)"
        
        // add them together and then to the view
        background.addSubview(label)
        view.addSubview(background)
        
        // countdown to 0
        countdown = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { countdown in
            // when its at 0, stop the timer and go back to start the game
            guard count > 0 else {
                countdown.invalidate()
                background.removeFromSuperview()
                return
            }
            count -= 1
            label.text = "\(count)"
        })
    }
    
    // If they press back while playing, stop the timer
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        if self.isMovingFromParent {
            timer.invalidate()
        }
    }
    
    // Keeps track of the timer, decrementing it over time until 0, which them swaps the screen
    @objc func counting() {
        remainingTime -= 1
        remainingTimeLabel.text = String(remainingTime)
        
        // when the timer hits 0 the game ends
        if remainingTime == 0 {
            timer.invalidate()
            
            // show an alert showing the player's score
            let alert = UIAlertController(title: "Game over!", message: "Final score: \(score)", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in switch action.style{
            default:
                // add the new score
                UDM.shared.addScore(newscore: GameScore(name: self.name, score: self.score))
                
                // show HighScore Screen
                let vc = self.storyboard?.instantiateViewController(identifier: "HighScoreViewController") as! HighScoreViewController
                self.navigationController?.pushViewController(vc, animated: true)
                vc.navigationItem.setHidesBackButton(true, animated: true)
            }}))
            self.present(alert, animated: true)
            
            
        }
    }
    
    // Function to remove some bubbles from the screen
    @objc func removeBubbles() {
        guard bubbles.count > 0 else { return }
        for _ in 0...Int.random(in: 0...bubbles.count-1) {
            bubbles[0].removeFromSuperview()
            bubbles.remove(at: 0)
        }
    }
    
    // Function to generate the bubbles
    @objc func generateBubbles() {
        // Setup the valid bubble spawning area
        let spawnArea: CGRect = gameAreaView.frame.offsetBy(dx: 1, dy: view.safeAreaInsets.top)
        
        var currentBubbles: Int = bubbles.count
        
        // While there aren't the max amount of bubbles, generate them until there are
        while currentBubbles < amountOfBubbles {
            // get a random position in the spawning area
            let xPosition = Int.random(in: Int(spawnArea.minX)...Int(spawnArea.maxX-50))
            let yPosition = Int.random(in: Int(spawnArea.minY)...Int(spawnArea.maxY-50))
            
            // create a new bounding rectangle from the coordinates
            let rect = CGRect(x: xPosition, y: yPosition, width: 50, height: 50)
            
            // make sure it doesn't collide with any of the existing bubbles
            var collides = false
            for bubble in bubbles {
                // if it collides with one, stop checking
                guard (!bubble.frame.intersects(rect)) else { collides = true; break }
                
            }
            
            // if the new bubble doesn't collide
            if !collides {
                // add a new bubble with the new bounding rectangle
                let bubble = Bubble(area: rect)
                bubble.animation()
                bubble.addTarget(self, action: #selector(bubblePressed), for: .touchUpInside)
                bubbles.append(bubble)
                self.view.addSubview(bubble)
                
                currentBubbles += 1
            }
            
        }
        
    }
    
    @IBAction func bubblePressed(_ sender: Bubble) {
        let bubbleScore = sender.score
        
        // if the previous bubble was the same, start the combo (since it's 2 or more) and multiply by 1.5
        if (previousBubble == bubbleScore) {
            score += Int(ceil(Double(bubbleScore) * 1.5))
        } else {
            // otherwise update the last bubble and add the base score
            previousBubble = bubbleScore
            score += bubbleScore
        }
        
        // update the score label with the new score
        scoreLabel.text = String(score)
        
        // remove pressed bubble from view
        sender.removeFromSuperview()
    }

}

// Class to manage the user defaults IO (User Defaults Manager)
class UDM {
    
    // store a static instance of the class to be used across modules
    static let shared = UDM()
    
    let STORAGE_KEY: String = "scores"
    
    let defaults = UserDefaults(suiteName: "zekii.saved.data")!
    
    // get the largest score from the stored list (should be the first based on the sorting algorithm)
    func getHighScore() -> Int {
        let scores: [GameScore] = getScores()
        guard !scores.isEmpty else { return 0 }
        return scores[0].score
    }
    
    // returns a list of all the scores
    func getScores() -> [GameScore] {
        var out: [GameScore] = []
        if let data = UDM.shared.defaults.value(forKey: STORAGE_KEY) as? Data {
            if let array = try? PropertyListDecoder().decode(Array<GameScore>.self, from: data) {
                out = array
            }
        }
        return out
    }
    
    // adds a new score into the list, relative to the other scores - sorting from highest to lowest
    func addScore(newscore: GameScore) {
        var currentscores = getScores()
        for (index, score) in currentscores.enumerated() {
            if score.score < newscore.score {
                currentscores.insert(newscore, at: index)
                UDM.shared.defaults.set(try? PropertyListEncoder().encode(currentscores), forKey: STORAGE_KEY)
                return
            }
        }
        currentscores.append(newscore)
        UDM.shared.defaults.set(try? PropertyListEncoder().encode(currentscores), forKey: STORAGE_KEY)
    }
}
