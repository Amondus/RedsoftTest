//
//  URLRequest+Extensions.swift
//  RedsoftTest
//
//  Created by Антон Захарченко on 22.10.2020.
//

import Foundation
import RxSwift
import RxCocoa

enum HttpMethod: String {
  case get = "GET"
  case post = "POST"
  case put = "PUT"
  case delete = "DELETE"
}

struct Resource<T: Decodable> {
  let url: URL
  let httpMethod: HttpMethod
}

extension URLRequest {
  static func load<T>(resource: Resource<T>) -> Observable<T> {
    return Observable.just(resource.url)
      .flatMap {url -> Observable<Data> in
        var request = URLRequest(url: url)
        request.httpMethod = resource.httpMethod.rawValue
        return URLSession.shared.rx.data(request: request)
    }.map { data -> T in
      return try JSONDecoder().decode(T.self, from: data)
    }
  }
}

