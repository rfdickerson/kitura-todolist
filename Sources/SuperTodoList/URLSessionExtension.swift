import Foundation
import MiniPromiseKit

extension URLSession {
    func dataTaskPromise(with url: URL) -> Promise<Data> {
        return Promise { fulfill, reject in
            let dataTask = URLSession(configuration: .default)
                .dataTask(with: url) {
                    data, response, error in
                    guard let d = data else {
                        reject(error!)
                        return
                    }
                    fulfill(d)
            }
            dataTask.resume()
        }
    }
}
