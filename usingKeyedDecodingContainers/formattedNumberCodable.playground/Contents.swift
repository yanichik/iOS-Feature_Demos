import UIKit

let json = """
{
    "product-count": 3,
    "product-array": [
        {
            "product": "snickers pack",
            "price": "$12.99"
        },
        {
            "product": "latte",
            "price": "$5.50"
        },
        {
            "product": "charger",
            "price": "$29.95"
        }
    ]
}
"""



struct Product: Codable {
    var count: Int
    var products: [Item]
    
    enum CodingKeys: String, CodingKey {
        case count = "product-count"
        case products = "product-array"
    }
}

struct Item: Codable {
    var product: String
    var price: NSNumber
    
    enum CodingKeys: String, CodingKey {
        case product
        case price
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        product = try container.decode(String.self, forKey: .product)
        let priceString = try container.decode(String.self, forKey: .product)
        
        let priceFormatter = NumberFormatter()
        priceFormatter.currencySymbol = "$"
        
        price = priceFormatter.number(from: priceString) ?? NSNumber()
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encodeIfPresent(price.stringValue, forKey: .price)
    }
}

do {
    let decoder = JSONDecoder()
    let products = try decoder.decode(Product.self, from: json.data(using: .utf16)!)
    print(products)
} catch {
    print("Decoding Error: \(error)")
}
