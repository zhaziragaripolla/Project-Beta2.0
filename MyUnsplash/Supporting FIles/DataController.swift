//
//  DataController.swift
//  MyUnsplash
//
//  Created by Zhazira Garipolla on 8/6/19.
//  Copyright © 2019 Бекдаулет Касымов. All rights reserved.
//

import CoreData

class DataController {
    
    static let shared = DataController()
    
    let persistentContainer: NSPersistentContainer
    
    // Context to store slangs.
    var viewContext: NSManagedObjectContext {
        return persistentContainer.viewContext
    }
    
    private init() {
        persistentContainer = NSPersistentContainer(name: "MyUnsplash")
    }
    
    func load(completion: (()->())? = nil) {
        persistentContainer.loadPersistentStores { storeDescritpion, error in
            guard error == nil else {
                fatalError(error!.localizedDescription)
            }
            completion?()
        }
    }
    
    func save() {
        do {
            try viewContext.save()
            print("Data is saved to context")
        }
            
        catch let error {
            print(error.localizedDescription)
        }
    }
    
    // MARK: Add slang
    func insert(_ photo: Photo) {
        
        // Creates a new slang in a view context.
        let entity = NSEntityDescription.entity(forEntityName: "StoredPhoto", in: viewContext)
        let newPhoto = NSManagedObject(entity: entity!, insertInto: viewContext)
        
        // Sets values to a new photo.
        newPhoto.setValue(photo.id, forKey: "id")
        newPhoto.setValue(photo.height, forKey: "height")
        newPhoto.setValue(photo.width, forKey: "width")
        newPhoto.setValue(photo.urls.regular!, forKey: "url")
        viewContext.insert(newPhoto)
        setState(photo: photo)
        save()
    }
    
    // MARK: Delete a slang
    func delete(_ photo: Photo) {
        let id = photo.id
        let fetchRequest: NSFetchRequest<StoredPhoto> = StoredPhoto.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
        
        do {
            let results = try viewContext.fetch(fetchRequest)
            for object in results {
                let objectData = object as NSManagedObject
                viewContext.delete(objectData)
            }
        } catch let error {
            print(error.localizedDescription)
        }
        
        setState(photo: photo)
        save()
    }
    
    
    func contains(id: String)->Bool {
        var results: [NSManagedObject] = []
        
        let fetchRequest: NSFetchRequest<StoredPhoto> = StoredPhoto.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %@", id)
            
        do {
            results = try viewContext.fetch(fetchRequest)
        }
        catch {
            fatalError(error.localizedDescription)
        }
       
        return results.count > 0
    }
    
    func setState(photo: Photo) {
        photo.isSaved = contains(id: photo.id)
    }
}

