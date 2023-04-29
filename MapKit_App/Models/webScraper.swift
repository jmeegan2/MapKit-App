//
//  webScraper.swift
//  MapKit_App
//
//  Created by James Meegan on 4/28/23.
//
import Foundation
import SwiftSoup

func scrapePrice() {
    let url = URL(string: "https://gasprices.aaa.com/")!
    
    let headers = [
        "User-Agent": "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/58.0.3029.110 Safari/537.3"
    ]
    
    var request = URLRequest(url: url)
    request.allHTTPHeaderFields = headers
    
    do {
        let html = try String(contentsOf: request.url!)
        let document = try SwiftSoup.parse(html)
        if let priceDiv = try document.select("div.mobi-average-price.mobi-average-price--red").first() {
            if let priceText = try priceDiv.select("p.price-text.price-text--red").first()?.text(),
               let priceNumbers = Double(priceText.replacingOccurrences(of: "[^0-9.]", with: "", options: .regularExpression)) {
                print("\n \(priceNumbers) \n" )
            }
        }
    } catch let error as NSError {
        print("Error while fetching HTML: \(error.localizedDescription)")
    } catch let error {
        print("Error while parsing HTML: \(error)")
    }
}
