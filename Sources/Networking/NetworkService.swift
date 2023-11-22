import Foundation

public final class NetworkService {
    public static let shared = NetworkService()
    
    public init() {}
    
    public func fetchData<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Invalid URL"])))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            guard let data = data else {
                completion(.failure(NSError(domain: "", code: -2, userInfo: [NSLocalizedDescriptionKey: "No data received"])))
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(T.self, from: data)
                completion(.success(decodedData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    public func fetchDataWithLimit<T: Decodable>(urlString: String, limit: Int, completion: @escaping (Result<T, Error>) -> Void) {
        let urlStringWithLimit = urlString + "?limit=\(limit)"
        fetchData(urlString: urlStringWithLimit, completion: completion)
    }
}

