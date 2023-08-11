import Foundation
import CoreData
import Fakery

class UserModel: ObservableObject {
    let container: NSPersistentContainer

    @Published var items: [User] = []
    
    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "formulary")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        let context = container.viewContext
        let request: NSFetchRequest<User> = User.fetchRequest()
        do {
            items = try context.fetch(request)
        } catch {
            print("Error fetching users: \(error)")
        }
    }

    func addItem() {
        let context = container.viewContext
        let faker = Faker(locale: "fr")
        let newItem = User(context: context)
        newItem.createdAt = Date()
        newItem.lastname = faker.name.lastName()
        newItem.firstname = faker.name.firstName()

        do {
            try context.save()
            items.append(newItem)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }

    func deleteItem(offsets: IndexSet) {
        let context = container.viewContext
        offsets.map { items[$0] }.forEach(context.delete)

        do {
            try context.save()
            items.remove(atOffsets: offsets)
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func deleteAllItems() {
        let context = container.viewContext
        
        do {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: "User")
            let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            try context.execute(batchDeleteRequest)
            
            try context.save()
            items = []
        } catch {
            print("Error deleting all items: \(error)")
        }
    }
}
