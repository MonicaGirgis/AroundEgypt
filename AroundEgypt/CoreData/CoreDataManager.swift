//
//  CoreDataManager.swift
//  Rawaj
//
//  Created by Monica Girgis Kamel on 02/06/2022.
//

import CoreData

class CoreDataManager{
    
    public static let shared : CoreDataManager = CoreDataManager()
    
    private init(){}
    
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "AroundEqypt")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    private var context : NSManagedObjectContext!{
        return persistentContainer.viewContext
    }
    
    //MARK: - Save CoreData
    private func saveContext(){
        if context.hasChanges{
            do{
                try context.save()
            }
            catch let error{
                print("Can't save context:",error)
            }
        }
    }
    
    //MARK: - Delete CoreData
    func delete(_ obj: NSManagedObject?) {
        guard let deleteObjc = obj else { return }
        context.delete(deleteObjc)
        print("Deleted Succesed")
        saveContext()
    }
    
    func delete(_ obj: [NSManagedObject]?) {
        guard let deleteObjc = obj else { return }
        deleteObjc.forEach({context.delete($0)})
        print("Deleted Succesed")
        saveContext()
    }
    
    // MARK: - Add Items
    func addItem(entityName: String, compilation : (NSManagedObject) -> Void){
        let obj = NSEntityDescription.insertNewObject(forEntityName: entityName, into: context)
        
        compilation(obj)
        
        saveContext()
    }
    
    // MARK: - Update Item
       func updateItem(){
           saveContext()
       }
    
    // MARK: - Get All Items
    
    func getItems<T>(entity: NSFetchRequest<T>)->([T]?){
        do{
            
            let  items = try context.fetch(entity)
            
            return (items)
            
        }
        catch let error{
            print("Can't Get items",error)
            return (nil)
        }
    }
}
