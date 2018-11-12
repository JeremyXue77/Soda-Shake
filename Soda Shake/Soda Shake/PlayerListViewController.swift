//
//  PlayerListViewController.swift
//  Soda Shake
//
//  Created by JeremyXue on 2018/11/10.
//  Copyright © 2018 JeremyXue. All rights reserved.
//

import UIKit

class PlayerListViewController: UIViewController {
    
    var players = [String]() {
        didSet {
            if players.count >= 8 {
                numberOfPlayers.textColor = #colorLiteral(red: 1, green: 0.1803921569, blue: 0.3882352941, alpha: 1)
            } else {
                numberOfPlayers.textColor = .black
            }
            numberOfPlayers.text = "Number Of Players: \(players.count)/8"
        }
    }
    
    @IBOutlet weak var playerListTableView: UITableView!
    @IBOutlet weak var numberOfPlayers: UILabel!
    @IBOutlet weak var actionBarButtonItem: UIBarButtonItem!
    
    @IBAction func startGame(_ sender: Any) {
        
        if players.count < 2 {
            let alertController = UIAlertController(title: "Error", message: "Multiplayer game must have /n more than two players to play", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(okAction)
            present(alertController, animated: true, completion: nil)
        } else if players.count > 8 {
            checkGame()
        } else {
            self.performSegue(withIdentifier: "goToGame", sender: nil)
        }
        
    }
    
    @IBAction func addNewPlayer(_ sender: Any) {
        let alertController = UIAlertController(title: "Add New Player(\(players.count + 1))", message: "Please enter playername", preferredStyle: .alert)
        alertController.addTextField { (textField) in
            textField.placeholder = "Player\(self.players.count + 1)"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let addAction = UIAlertAction(title: "Confirm", style: .default) { (action) in
            if let textField = alertController.textFields?.first {
                if textField.text != "" {
                    self.players.append(textField.text!)
                } else {
                    self.players.append("Player\(self.players.count + 1)")
                }
                self.playerListTableView.insertRows(at: [[0,self.players.count - 1]], with: .top)
                self.playerListTableView.scrollToRow(at: [0,self.players.count - 1], at: .bottom, animated: true)
            }
        }
        alertController.addAction(addAction)
        alertController.addAction(cancelAction)
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        playerListTableView.dataSource = self
        playerListTableView.delegate = self
        playerListTableView.isEditing = true
        playerListTableView.allowsSelectionDuringEditing = true
    }
    
    func checkGame() {
        let alertController = UIAlertController(title: "Start Game", message: "When the player has less than eight,\n you can have a better experience.", preferredStyle: .alert)
        let startAction = UIAlertAction(title: "Start", style: .default) { (action) in
            self.performSegue(withIdentifier: "goToGame", sender: nil)
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(startAction)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension PlayerListViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return players.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.imageView?.image = UIImage(named: "sodada")
        cell.imageView?.sizeToFit()
        cell.imageView?.tintColor = #colorLiteral(red: 0.2235294118, green: 0.2431372549, blue: 0.2745098039, alpha: 1)
        cell.textLabel?.text = players[indexPath.row]
        cell.textLabel?.textColor = #colorLiteral(red: 0.2235294118, green: 0.2431372549, blue: 0.2745098039, alpha: 1)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let actionSheet = UIAlertController(title: "Select Player \(players[indexPath.row])", message: "What do you want to do?", preferredStyle: .actionSheet)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let editAction = UIAlertAction(title: "Change Name", style: .default) { (_) in
            let alertController = UIAlertController(title: "Change Playername", message: "Please enter a new playername", preferredStyle: .alert)
            alertController.addTextField { (textField) in
                textField.placeholder = "New playername"
            }
            let changeAction = UIAlertAction(title: "Change", style: .default, handler: { (_) in
                if let textField = alertController.textFields?.first {
                    if textField.text != "" {
                        self.players[indexPath.row] = textField.text!
                        self.playerListTableView.reloadRows(at: [indexPath], with: .automatic)
                    }
                }
            })
            
            alertController.addAction(changeAction)
            alertController.addAction(cancelAction)
            
            self.present(alertController, animated: true, completion: nil)
        }
        let removeAction = UIAlertAction(title: "Delete Player", style: .default) { (_) in
            self.players.remove(at: indexPath.row)
            self.playerListTableView.deleteRows(at: [indexPath], with: .automatic)
        }

        actionSheet.addAction(cancelAction)
        actionSheet.addAction(editAction)
        actionSheet.addAction(removeAction)
        
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movePlayer = players.remove(at: sourceIndexPath.row)
        players.insert(movePlayer, at: destinationIndexPath.row)
        print(players)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height / 8
    }
}
