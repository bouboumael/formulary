//
//  ContentView.swift
//  formulary
//
//  Created by Mael Chariault on 11/08/2023.
//

import SwiftUI
import CoreData
import Fakery

struct ContentView: View {

    @StateObject private var users = UserModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(users.items) { item in
                    NavigationLink {
                        Text("Item at \(item.createdAt!, formatter: itemFormatter)")
                    } label: {
                        VStack {
                            Text(item.createdAt!, formatter: itemFormatter)
                            HStack {
                                Text(item.lastname!)
                                Text(item.firstname!)
                            }
                        }
                    }
                }
                .onDelete(perform: users.deleteItem)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing)
                {
                    EditButton()
                }
                ToolbarItem {
                    Button {
                        users.addItem()
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                }
                ToolbarItem {
                    Button(action: {
                        users.deleteAllItems()
                    }) {
                        Label("Delete", systemImage: "trash")
                    }
                }
            }
            Text("Select an item")
        }
    }
}



private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
