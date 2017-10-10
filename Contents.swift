//: A UIKit based Playground for presenting user interface
  
import UIKit
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

public struct MediaWikiQueryDetails : Codable {
  public let categorymembers : [MediaWikiQueryResultItem]
}

public struct MediaWikiQueryResult : Codable {
  public let query : MediaWikiQueryDetails
}

public struct MediaWikiQueryResultItem : Codable {
  public let pageid : Int
  public let ns : Int
  public let title : String
}

guard let url = URL(string: "https://en.wikipedia.org/w/api.php?action=query&prop=revisions&rvprop=content&rvsection=0&titles=pizza&format=json") else {
  PlaygroundPage.current.finishExecution()
}



class MyViewController : UITableViewController {
  public var currentTask : URLSessionTask?
  public var categorymembers : [MediaWikiQueryResultItem]? {
    didSet {
      self.tableView.reloadData()
      PlaygroundPage.current.finishExecution()
    }
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    let task = URLSession.shared.dataTask(with: url) { (data, _, error) in
      guard let data = data else {
        PlaygroundPage.current.finishExecution()
      }
      if error != nil {
        PlaygroundPage.current.finishExecution()
      }
      
      let decoder = JSONDecoder()
      guard let result = try? decoder.decode(MediaWikiQueryResult.self, from: data) else {
        PlaygroundPage.current.finishExecution()
      }
      
      self.categorymembers = result.query.categorymembers
    }
    self.currentTask = task
  }
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return self.categorymembers?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell  = UITableViewCell(style: .default, reuseIdentifier: "identifier")
    
    if let categorymember = self.categorymembers?[indexPath.row]  {
      cell.textLabel?.text = categorymember.title
    }
    
    return cell
  }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
