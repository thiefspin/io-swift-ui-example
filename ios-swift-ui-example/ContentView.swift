//
//  ContentView.swift
//  ios-swift-ui-example
//
//  Created by Michael Howard on 2023/01/19.
//

import SwiftUI

struct Wrapper: Decodable {
    let Results: [CarManufacturer]
}

struct CarManufacturer {
    let country: String?
    let commonName: String?
    let id: Int?
    var name: String?
}

extension CarManufacturer: Decodable {
    enum CodingKeys: String, CodingKey {
        case country = "Country"
        case commonName = "Mfr_CommonName"
        case id = "Mfr_ID"
        case name = "Mfr_Name"
    }
}

struct ContentView: View {
    
    @State var selection: Int? = nil
    @State var isLinkActive = false
    
    @State var text: String = "Hello There"
    @State var text2: String = ""
    @State var text3: String = ""
    
    @State var labels: [String : String] = [
            "header" : "Initializing the app...",
            "footer" : "Example App Inc"
            
        ]
    
    var body: some View {
        NavigationStack {
            VStack {
                Text(labels["header"]!)
                Spacer()
                
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundColor(.accentColor)
                Text(text)
                Text(text2)
                Text(text3)
                Button("Press Me") {
                    text = "I'm fetching the things..."
                    text2 = ""
                    text3 = ""
                    fetch {list in
                        text = list[0].commonName ?? "Oops that did not work..."
                        text2 = list[0].country ?? ""
                        text3 = list[0].name ?? ""
                    }
                }
                .frame(width: 150, height: 50)
                .font(.title)
                .foregroundColor(Color.white)
                .background(Color.green)
                .cornerRadius(10)
                
                NavigationLink(destination: AnotherView(), tag: 1, selection: $selection) {
                    Button(action: {
                        self.selection = 1
                    }) {
                        HStack {
                            Spacer()
                            Text("Navigate").foregroundColor(Color.white)
                            Spacer()
                        }
                    }
                    .frame(width: 150, height: 50)
                    .font(.title)
                    .foregroundColor(Color.white)
                    .background(Color.green)
                    .cornerRadius(10)
                }
                
                
//                NavigationLink(destination: AnotherView()) {
//                    Text("Do Something")
//                }
                
                Spacer()
                
                Text(labels["footer"]!).foregroundColor(.white)
            }.onAppear(perform: initialize).background(
                Image("app-background")
                            .resizable()
                            .scaledToFill()
                            .edgesIgnoringSafeArea(.all)
                            .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
        }
    }
    
    private func initialize() {
        Timer.scheduledTimer(withTimeInterval: 4.0, repeats: false) { timer in
            labels["header"]! = "Up and running!"
        }
    }
    
    func fetch(completionHandler: @escaping ([CarManufacturer]) -> Void) {
        let url = composeUrl(url: "https://vpic.nhtsa.dot.gov/api/vehicles/getallmanufacturers")

        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
          if let error = error {
            print("Error with fetching films: \(error)")
            return
          }
          
          guard let httpResponse = response as? HTTPURLResponse,
                (200...299).contains(httpResponse.statusCode) else {
              print("Error with the response, unexpected status code: \(String(describing: response))")
            return
          }

          if let data = data,
            let carManufacturers = try? JSONDecoder().decode(Wrapper.self, from: data) {
              completionHandler(carManufacturers.Results )
          }
        })
        task.resume()
      }
}

func composeUrl(url: String) -> URL {
    let tmp = URL(string: url)!
    let queryItem = URLQueryItem(name: "format", value: "json")
    return tmp.appending(queryItems: [queryItem])
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
