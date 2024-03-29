import UIKit

let json = """
{
  "name": "John Doe",
  "age": 30,
  "address": "home",
  "birthday": "1992-01-01",
  "contact-information": {
    "email": "john@example.com",
    "phone_number": "123-456-7890"
  }
}
"""

struct Person: Codable {
    var name: String
    var age: Int
    var address: Address
    var birthday: Date
    var contactInfo: ContactInfo

    enum CodingKeys: String, CodingKey {
        case name
        case age
        case address
        case birthday
        case contactInfo = "contact-information"
    }

    struct ContactInfo: Codable {
        var email: String
        var phoneNumber: String
    }

    enum Address: String, Codable {
        case home
        case work
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        name = try container.decode(String.self, forKey: .name)
        age = try container.decode(Int.self, forKey: .age)
        address = try container.decode(Address.self, forKey: .address)
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let birthdayString = try? container.decode(String.self, forKey: .birthday) {
            birthday = dateFormatter.date(from: birthdayString) ?? Date()
        } else {
            birthday = Date()
        }
        contactInfo = try container.decode(ContactInfo.self, forKey: .contactInfo)
    }
}

let jsonData = json.data(using: .utf8)!

do {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    let person = try decoder.decode(Person.self, from: jsonData)
    print(person.birthday)
} catch {
    print("Error decoding JSON: \(error)")
}
