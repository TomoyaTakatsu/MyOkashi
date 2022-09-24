//
//  ViewController.swift
//  MyOkashi
//
//  Created by Tomoya takatsu on 2022/07/31.
//

import UIKit
import SafariServices

class ViewController: UIViewController , UISearchBarDelegate,UITableViewDataSource, UITableViewDelegate, SFSafariViewControllerDelegate {
    
    @IBOutlet weak var searchText: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var okashiList : [(name: String , maker: String , link: URL , imageUrl: URL)] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        searchText.delegate = self
        tableView.delegate = self
        searchText.placeholder = "お菓子の名前を入力してください"
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "okashiCell", for: indexPath)
        cell.textLabel?.text = okashiList[indexPath.row].name
        if let imageData = try? Data(contentsOf: okashiList[indexPath.row].imageUrl){
            cell.imageView?.image = UIImage(data: imageData)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return okashiList.count
    }
    
    // Cell押下時にWebVIewに飛ばす
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let safariViewController = SFSafariViewController(url: okashiList[indexPath.row].link)
        
        safariViewController.delegate = self
        
        present(safariViewController, animated: true, completion: nil)
    }
    
    // WebViewを閉じる
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
        
        if let searchWord = searchBar.text {
            print(searchWord)
            searchOkashi(searchWord: searchWord)
        }
    }
    
    // 検索ワードでAPIを呼び出してCellに情報を詰める
    private func searchOkashi(searchWord: String) {
        guard let searchWord_encode = searchWord.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return
        }
        
        guard let req_url = URL(string: "https://sysbird.jp/toriko/api/?apikey=guest&format=json&keyword=\(searchWord_encode)&max=10&order=r") else { return }
        
        print("req_url:" , req_url)
        
        let req = URLRequest(url: req_url)
        
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        
        let task = session.dataTask(with: req, completionHandler: {
            (data , response , error) in
            
            session.finishTasksAndInvalidate()
            
            do {
                let decoder = JSONDecoder()
                
                let json = try decoder.decode(ResultJson.self, from: data!)
                
                if let itemList = json.item {
                    self.okashiList.removeAll()
                    for item in itemList {
                        if let name = item.name , let maker = item.maker , let link = item.url, let imageUrl = item.image {
                            let okashi = (name, maker , link , imageUrl)
                            self.okashiList.append(okashi)
                        } else {continue}
                    }
                }
                
                self.tableView.reloadData()
                
            }catch{
                print(error)
            }
        })
        
        task.resume()
    }
    
}

