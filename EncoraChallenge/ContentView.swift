//
//  ContentView.swift
//  EncoraChallenge
//
//  Created by MAC1DIGITAL20 on 22/06/23.
//
import SwiftUI

struct ContentView: View {
    @State private var isLoading = true
    @State private var posts: [Post] = []
    @State private var searchText = ""

    var filteredPosts: [Post] {
        if searchText.isEmpty {
            return posts
        } else {
            return posts.filter { $0.title.lowercased().contains(searchText.lowercased()) }
        }
    }

    var body: some View {
        VStack {
            
            if isLoading {
                LoadingView()
            } else {
                SearchBar(text: $searchText)
                    .padding(.top)
                List(filteredPosts) { post in
                    VStack(alignment: .leading) {
                        Text(post.title)
                            .font(.headline)
                        Text(post.body)
                            .font(.subheadline)
                    }
                }
            }
        }
        .onAppear {
            loadData()
        }
    }

    func loadData() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            guard let url = URL(string: "https://gorest.co.in/public/v1/posts") else {
                return
            }

            let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
                guard let data = data else {
                    return
                }

                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let response = try decoder.decode(ResponseData.self, from: data)
                    DispatchQueue.main.async {
                        self.isLoading = false
                        self.posts = response.data
                    }
                } catch {
                    print("Error: \(error)")
                }
            }

            task.resume()
        }
    }
}


struct LoadingView: View {
    var body: some View {
        ProgressView("Loading...")
    }
}

struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(8)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .disableAutocorrection(true)

            Button(action: {
                text = ""
            }) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
                    .padding(8)
                    .opacity(text.isEmpty ? 0 : 1)
            }
        }
        .padding(.horizontal)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
