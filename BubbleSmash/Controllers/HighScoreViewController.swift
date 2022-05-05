//
//  HighScoreViewController.swift
//  BubbleSmash
//
//  Created by Zach Clare on 26/4/2022.
//

import UIKit

// struct used to store all the game scores - needs to be codable to be encoded and decoded when stored
struct GameScore: Codable {
    var name: String
    var score: Int
}

class HighScoreViewController: UIViewController {

    @IBOutlet weak var scoreTable: UITableView!
    
    // get the scores from the user defaults
    let scores: [GameScore] = UDM.shared.getScores()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // set the delegate and data source to this view
        scoreTable.delegate = self
        scoreTable.dataSource = self
    }
    
    // return the user to the main page when button clicked
    @IBAction func returnMainPage(_ sender: UIButton) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension HighScoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // empty, just needed for setting the delegate
    }
}

extension HighScoreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // adds cells based on how many scores there are
        return scores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // lays the table out with the info
        let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath)
        
        let score = scores[indexPath.row]
        cell.textLabel?.text = score.name
        cell.detailTextLabel?.text = "\(score.score)"
        
        return cell
    }
}
