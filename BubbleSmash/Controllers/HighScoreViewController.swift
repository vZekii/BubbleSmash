//
//  HighScoreViewController.swift
//  BubbleSmash
//
//  Created by Zach Clare on 26/4/2022.
//

import UIKit

struct GameScore: Codable {
    var name: String
    var score: Int
}

class HighScoreViewController: UIViewController {

    @IBOutlet weak var scoreTable: UITableView!
    
    let scores: [GameScore] = UDM.shared.getScores()
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scoreTable.delegate = self
        scoreTable.dataSource = self
    }
    

    @IBAction func returnMainPage(_ sender: UIButton) {
        
        self.navigationController?.popToRootViewController(animated: true)
    }
}

extension HighScoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("tapped")
    }
}

extension HighScoreViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return scores.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "tablecell", for: indexPath)
        
        let score = scores[indexPath.row]
        cell.textLabel?.text = score.name
        cell.detailTextLabel?.text = "\(score.score)"
        
        return cell
    }
}
