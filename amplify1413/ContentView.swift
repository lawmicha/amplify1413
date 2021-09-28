//
//  ContentView.swift
//  amplify1413
//
//  Created by Law, Michael on 9/27/21.
//


import SwiftUI
import Amplify
import AmplifyPlugins
import Combine

class ContentViewModel: ObservableObject {
    @Published var user: User? = nil
    @Published var friend: Friend? = nil
    
    @Published var user2: User2? = nil
    @Published var friend2: Friend2? = nil
    
    func signIn() {
        // this user was created and confirmed via AWS CLI, see README.md for more details
        Amplify.Auth.signIn(username: "michael", password: "password") { result in
            switch result {
            case .success(let result):
                print(result)
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    func signOut() {
        Amplify.Auth.signOut { result in
            switch result {
            case .success:
                print("signed out")
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    func saveUser() {
        let user = User(username: "michael")
        Amplify.API.mutate(request: .create(user)) { result in
            switch result {
            case .success(let response):
                switch response {
                case .success(let user):
                    print("Saved user \(user)")
                    DispatchQueue.main.async {
                        self.user = user
                    }
                case .failure(let graphQLError):
                    print("\(graphQLError)")
                }
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    func saveUser2() {
        let user2 = User2(username: "michael")
        Amplify.API.mutate(request: .create(user2)) { result in
            switch result {
            case .success(let response):
                switch response {
                case .success(let user2):
                    print("Saved user2 \(user2)")
                    DispatchQueue.main.async {
                        self.user2 = user2
                    }
                case .failure(let graphQLError):
                    print("\(graphQLError)")
                }
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    func saveFriend() {
        guard let user = user else {
            print("User is not saved yet")
            return
        }
        let friend = Friend(userId: user.id, user: user, username: "michael")
        Amplify.API.mutate(request: .create(friend)) { result in
            switch result {
            case .success(let response):
                switch response {
                case .success(let friend):
                    print("Saved friend \(friend)")
                    DispatchQueue.main.async {
                        self.friend = friend
                    }
                case .failure(let graphQLError):
                    print("\(graphQLError)")
                }
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    func saveFriend2() {
        guard let user2 = user2 else {
            print("User2 is not saved yet")
            return
        }
        let friend2 = Friend2(user: user2, username: "michael")
        Amplify.API.mutate(request: .create(friend2)) { result in
            switch result {
            case .success(let response):
                switch response {
                case .success(let friend2):
                    print("Saved friend2 \(friend2)")
                    DispatchQueue.main.async {
                        self.friend2 = friend2
                    }
                case .failure(let graphQLError):
                    print("\(graphQLError)")
                }
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    func queryUserAndGetFriendsLazyLoad() {
        guard let user = user else {
            print("User is not saved yet")
            return
        }
        Amplify.API.query(request: .get(User.self, byId: user.id)) { result in
            switch result {
            case .success(let response):
                switch response {
                case .success(let user):
                    print("Queried user \(user)")
                    if let friends = user?.friends {
                        friends.fetch { result in
                            switch result {
                            case .success:
                                print("Fetch completed \(friends.count)")
                                
                            case .failure(let error):
                                print("\(error)")
                            }
                        }
                        //print("Got friends \(friends.count)")
                    } else {
                        print("Couldn't get friends")
                    }
                case .failure(let graphQLError):
                    print("\(graphQLError)")
                }
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    func queryUserAndGetFriendsLazyLoad2() {
        guard let user2 = user2 else {
            print("User2 is not saved yet")
            return
        }
        Amplify.API.query(request: .get(User2.self, byId: user2.id)) { result in
            switch result {
            case .success(let response):
                switch response {
                case .success(let user2):
                    print("Queried user2 \(user2)")
                    if let friends = user2?.friends {
                        friends.fetch { result in
                            switch result {
                            case .success:
                                print("Fetch completed \(friends.count)")
                                
                            case .failure(let error):
                                print("\(error)")
                            }
                        }
                        //print("Got friends \(friends.count)")
                    } else {
                        print("Couldn't get friends")
                    }
                case .failure(let graphQLError):
                    print("\(graphQLError)")
                }
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    func queryUserAndGetFriends() {
        guard let user = user else {
            print("User is not saved yet")
            return
        }
        Amplify.API.query(request: getUserWithFriendsQuery(id: user.id)) { result in
            switch result {
            case .success(let response):
                switch response {
                case .success(let user):
                    print("Queried user \(user)")
                    if let friends = user?.friends {
                        friends.fetch { result in
                            switch result {
                            case .success:
                                print("Fetch completed \(friends.count)")
                                if friends.hasNextPage() {
                                    print("Has next page, retrieve nextToken")
                                    
                                  
                                    
                                }
                                
                            case .failure(let error):
                                print("\(error)")
                            }
                        }
                    } else {
                        print("Couldn't get friends")
                    }
                case .failure(let graphQLError):
                    print("\(graphQLError)")
                }
            case .failure(let error):
                print("\(error)")
            }
        }
    }
    
    func getUserWithFriendsQuery(id: String, nextToken: String? = nil) -> GraphQLRequest<User?> {
        var document = """
        query MyQuery {
          getUser(id: "\(id)") {
            createdAt
            defaultPlaylist
            isSubscribedOneSignal
            id
            mobileDefaultDestinationPlaylist
            owner
            primaryMusicStream
            publicPlaylists
            sharedPlaylists
            updatedAt
            username
            screenAppearance
            friends(limit: 10) {
              nextToken
              items {
                createdAt
                id
                musicStreamId
                owner
                primaryMusicStream
                updatedAt
                userId
                username
              }
            }
          }
        }
        """
        if let nextToken = nextToken {
            document = """
            query MyQuery {
              getUser(id: "\(id)") {
                createdAt
                defaultPlaylist
                isSubscribedOneSignal
                id
                mobileDefaultDestinationPlaylist
                owner
                primaryMusicStream
                publicPlaylists
                sharedPlaylists
                updatedAt
                username
                screenAppearance
                friends(limit: 10, nextToken: "\(nextToken)") {
                  nextToken
                  items {
                    createdAt
                    id
                    musicStreamId
                    owner
                    primaryMusicStream
                    updatedAt
                    userId
                    username
                  }
                }
              }
            }
            """
        }

        return GraphQLRequest<User?>(document: document,
                                    variables: nil,
                                    responseType: User?.self,
                                    decodePath: "getUser")
    }
    
}


struct ContentView: View {
    @StateObject var vm = ContentViewModel()
    
    var body: some View {
        VStack {
            VStack {
                Text("Latest User:")
                Text(self.vm.user?.id ?? "None")
                Text("Latest Friend:")
                Text(self.vm.friend?.id ?? "None")
            }
            VStack {
                Button("Sign in", action: self.vm.signIn)
                Button("Sign out", action: self.vm.signOut)
                Button("save user", action: self.vm.saveUser)
                Button("save friend", action: self.vm.saveFriend)
                
                Button("Query for user and lazy load friends", action: self.vm.queryUserAndGetFriendsLazyLoad)
                
                Button("Query for user and friends together", action: self.vm.queryUserAndGetFriends)
            }
            VStack {
                Text("Latest User2:")
                Text(self.vm.user2?.id ?? "None")
                Text("Latest Friend2:")
                Text(self.vm.friend2?.id ?? "None")
            }
            VStack {
                Button("save user2", action: self.vm.saveUser2)
                Button("save friend2", action: self.vm.saveFriend2)
                
                Button("Query for user and lazy load friends", action: self.vm.queryUserAndGetFriendsLazyLoad2)
                
                //Button("Query for user and friends together", action: self.vm.queryUserAndGetFriends2)
            }
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
