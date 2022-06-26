import UIKit

class ViewController: UIViewController {
  
  var wordsForGame = ["apple", "ios", "iphone", "swift"]
  var listOfWords = [String]()
  let incorrectMovesAllowed = 7
  var totalWins = 0 {
    didSet {
      newRound()
    }
  }
  var totalLoses = 0 {
    didSet {
      newRound()
    }
  }
  
  @IBOutlet weak var treeImageView: UIImageView!
  @IBOutlet weak var correctWordLabel: UILabel!
  @IBOutlet weak var scoreLabel: UILabel!
  
  @IBOutlet var letterButtons: [UIButton]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    listOfWords = wordsForGame
    newRound()
  }
  
  var currentGame: Game!
  
  func newRound(){
    usleep(500000)
    if !listOfWords.isEmpty {
      let newWord = listOfWords.removeFirst()
      currentGame = Game(word: newWord, incorrectMovesRemaining: incorrectMovesAllowed,guessedLetters: [])
      print("New round starts!")
      print("Word to guess: \(newWord)")
      updateUI()
    } else {
      listOfWords = wordsForGame
      restartGame()
    }
  }
  
  func enableLetterButtons(_ enable:Bool) {
    for button in letterButtons {
      button.isEnabled = enable
    }
  }
  
  func updateGameState(){
    if currentGame.incorrectMovesRemaining == 0 {
      totalLoses += 1
      enableLetterButtons(true)
    } else if currentGame.word == currentGame.formattedWord {
      totalWins += 1
      enableLetterButtons(true)
    } else {
      updateUI()
    }
  }
  
  func updateUI(){
    var letters = [String]()
    for letter in currentGame.formattedWord {
      letters.append(String(letter))
    }
    let wordWithSpacing = letters.joined(separator: " ")
    correctWordLabel.text = wordWithSpacing
    scoreLabel.text = "Wins:\(totalWins) - Loses:\(totalLoses)"
    treeImageView.image = UIImage(named: "Tree \(currentGame.incorrectMovesRemaining)")
  }
  
  func restartGame() {
    let dialogMessage = UIAlertController(title: "Game finished", message: "Result:\nWins:\(totalWins) - Loses:\(totalLoses)\nRestart Game?", preferredStyle: .alert)
    // Create OK button with action handler
    let ok = UIAlertAction(title: "OK", style: .default, handler: { (action) -> Void in
      self.listOfWords = self.wordsForGame
      self.enableLetterButtons(true)
      self.newRound()
    })
    let cancel = UIAlertAction(title: "Cancel", style: .cancel) { (action) -> Void in
      exit(1)
    }
    dialogMessage.addAction(ok)
    dialogMessage.addAction(cancel)
    
    self.present(dialogMessage, animated: true, completion: nil)
  }

  @IBAction func letterButtonPressed(_ sender: UIButton) {
    sender.isEnabled = false
    let letterString = sender.configuration!.title!
    let letter = Character(letterString.lowercased())
    currentGame.playerGuessed(letter: letter)
    print("Letter pressed: \(letter)")
    updateGameState()
  }
  
}

