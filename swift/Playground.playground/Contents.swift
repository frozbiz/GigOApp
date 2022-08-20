import UIKit

//struct Gig: Hashable, Codable {
//    var id: Int
//    var name: String
//    var date: String?
//    var description: String
//    var status: Int?
//    var comment: String?
//    var datestring: String {
//        if let date {
//            let df = DateFormatter()
//            df.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
//            df.dateFormat = "MM/dd/yyyy"
//            if let parsedDate = df.date(from: date) {
//                parsedDate
//                // Convert to a string
//                df.dateFormat = "MM/dd/yyyy EEE hh:mma"
//                return df.string(from: parsedDate)
//            }
//        }
//        return "<unset>"
//    }
//}
//
//var gig = Gig(id:1, name: "Foo", date:"08/16/2022", description: "N/A")
//
//var datestring = gig.datestring
//
//gig = Gig(id:1, name: "Foo", description: "N/A")
//
//datestring = gig.datestring
//
//
//var foo = URLComponents()
//foo.queryItems = [URLQueryItem(name: "email", value: "MyEmail"),
//                  URLQueryItem(name: "password", value: "MyPassword")]
//
//print(foo.url?.relativeString)
//print(foo.query!)

let cookie = HTTPCookie(properties: [.name: "auth", .path: "/", .domain: "www.google.com", .value: "Hello"])!
try! await URLSession.shared.data(from: URL(string: "https://www.google.com")!)

let cookies = HTTPCookieStorage.shared.cookies!
let realCookie = cookies[0]
let cookieDict = realCookie.properties!
let data = try! NSKeyedArchiver.archivedData(withRootObject: cookieDict, requiringSecureCoding: true)
UserDefaults.standard.set(data, forKey: "cookie")
let test = UserDefaults.standard.object(forKey: "cookie") as? Data

let retCookieDict = NSKeyedUnarchiver.unarchiveObject(with: test!) as? [HTTPCookiePropertyKey : Any]

if let retCookieDict {
    let newCookie = HTTPCookie(properties: retCookieDict)
    newCookie == realCookie

//    retCookieDict.keys == cookieDict.keys
//    for (key, val) in retCookieDict {
//        if let val = val as? String {
//            print(val == cookieDict[key] as! String)
//        } else if let val = val as? Int {
//            print(val == cookieDict[key] as! Int)
//        } else if let val = val as? Date {
//            print(val == cookieDict[key] as! Date)
//        } else {
//            print(val)
//        }
//
//    }
////    retCookieDict == cookieDict
}

//let foo = cookieDict!.reduce(into: [String:Encodable]()) { partialResult, item in
//    partialResult[item.key.rawValue] = item.value
//}
//
//let json = JSONEncoder().encode(foo)
//([String:any Encodable], { (partialResult:[String:any Encodable], key: HTTPCookiePropertyKey, value: Any) inokieDict)
//UserDefaults.standard.set(cookie!, forKey: "cookie")
//let test = UserDefaults.standard.object(forKey: "cookie")


print(test)
