//
//  GigOApi.swift
//  Gig-O
//
//  Created by Lee Keyser-Allen on 8/18/22.
//

import Foundation


class GigOApi {
    static let baseUrl = URL(string: "https://www.gig-o-matic.com/api/")!
    static func fetch<T: Decodable> (_ path:String) async -> T? {
        let url = baseUrl.appending(path: path)
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            if let response = response as? HTTPURLResponse {
                if response.statusCode == 200 {
                    // Not sure if this is necessary, but this is how the other system works, so ...
                    stashAuthCookie()
                    let decoder = JSONDecoder()
                    return try decoder.decode(T.self, from: data)
                }
            }
            return nil
        } catch {
            print("Something went wrong!")
            return nil
        }
    }

    static func fetchAuthCookieFromCache() -> HTTPCookie? {
        let cookies = HTTPCookieStorage.shared.cookies(for: baseUrl) ?? []
        for cookie in cookies {
            if cookie.name == "auth" {
                return cookie
            }
        }
        return nil
    }

    static let cookieKey = "authToken"
    static func fetchAuthCookieFromUserDefaults() -> HTTPCookie? {
        if let cookieData = UserDefaults.standard.object(forKey: cookieKey) as? Data {
            if let cookieDict = NSKeyedUnarchiver.unarchiveObject(with: cookieData) as? [HTTPCookiePropertyKey : Any] {
                return HTTPCookie(properties: cookieDict)
            }
        }
        return nil
    }

    static func checkAndLoadCookieStore() -> HTTPCookie? {
        if let cookie = fetchAuthCookieFromCache() {
            return cookie
        }

        if let cookie = fetchAuthCookieFromUserDefaults() {
            HTTPCookieStorage.shared.setCookie(cookie)
            return cookie
        }

        return nil
    }

    static func stashAuthCookie() {
        if let cookie = fetchAuthCookieFromCache() {
            if let cookieDict = cookie.properties {
                do {
                    let data = try NSKeyedArchiver.archivedData(withRootObject: cookieDict, requiringSecureCoding: true)
                    UserDefaults.standard.set(data, forKey: cookieKey)
                } catch {
                    // Do nothing if we can't do something
                    print("GigOApi.stashAuthCookie: Unexpected Exception")
                }
            }
        }
    }

    static func deletePersistedAuthCookie() {
        UserDefaults.standard.removeObject(forKey: cookieKey)
    }

    static func tokenForAuthCookie(cookie: HTTPCookie) -> any StringProtocol {
        if let ix = cookie.value.firstIndex(of: "|") {
            return cookie.value[..<ix]
        }
        return cookie.value
    }

    static func authCookiesDiffer(lhs: HTTPCookie, rhs: HTTPCookie) -> Bool {
        tokenForAuthCookie(cookie: lhs).compare(tokenForAuthCookie(cookie: rhs)) != .orderedSame
    }

    static func fetchGigs() async -> [Gig]? {
        return await fetch("agenda")
    }

    static func fetchBands() async -> [Band]? {
        return await fetch("bands")
    }

    static func fetchGigPlans(gig:Gig) async -> [MemberPlan]? {
        return await fetch("gig/plans/\(gig.id)")
    }

    static func logIn(username:String, password:String) async -> Bool {
        var loginData = URLComponents()
        loginData.queryItems = [URLQueryItem(name: "email", value: username),
                                URLQueryItem(name: "password", value: password)]

        let body = loginData.query?.data(using: .utf8)
        if let body {
            let url = baseUrl.appending(path: "authenticate")
            var req = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalCacheData)
            req.httpMethod = "POST"
            req.setValue("application/x-www-form-urlencoded", forHTTPHeaderField:"Content-Type");
            req.httpBody = body
            do {
                let (_, response) = try await URLSession.shared.data(for: req)
                if let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        // If we log in, try to store the cookie
                        stashAuthCookie()
                        return true
                    }
                }
            } catch {
                print("Something went wrong!")
            }
        }
        return false
    }

    static func logOut() async -> Bool {
        var success = false
        if checkAndLoadCookieStore() != nil {
            deletePersistedAuthCookie()
            let url = baseUrl.appending(path: "logout")
            var req = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalCacheData)
            req.httpMethod = "POST"
            do {
                let (_, response) = try await URLSession.shared.data(for: req)
                if let response = response as? HTTPURLResponse {
                    success = response.statusCode == 200
                }
            } catch {
                print("GigOApi.loggedIn: Something went wrong!")
            }
        }
        return success
    }

    static func loggedIn() async -> Bool {
        if checkAndLoadCookieStore() != nil {
            let url = baseUrl.appending(path: "session")
            var req = URLRequest(url: url,
                                 cachePolicy: .reloadIgnoringLocalCacheData)
            req.httpMethod = "POST"
            do {
                let (_, response) = try await URLSession.shared.data(for: req)
                if let response = response as? HTTPURLResponse {
                    return response.statusCode == 200
                }
            } catch {
                print("GigOApi.loggedIn: Something went wrong!")
            }
        }
        return false
    }
}
