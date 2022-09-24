import Foundation

struct ResultJson: Codable{
    // 複数要素
    let item:[ItemJson]?
}

struct ItemJson: Codable{
    // お菓子の名称
    let name: String?
    // お菓子のメーカー
    let maker: String?
    // 掲載URL
    let url: URL?
    // 画像のURL
    let image: URL?
    
}

struct Okashi: Codable{
    // お菓子の名称
    var name: String?
    // お菓子のメーカー
    var maker: String?
    // 掲載URL
    var url: URL?
    // 画像のURL
    var imageUrl: URL?
    
}


