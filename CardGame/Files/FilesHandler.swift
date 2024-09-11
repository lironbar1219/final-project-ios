import Foundation

class FilesHandler {

    
    static func getCardsFileNames() -> [String]? {
        let fileManager = FileManager.default
        
        guard let resourcePath = Bundle.main.resourcePath else {
            return nil
        }
        
        do {
            let contents = try fileManager.contentsOfDirectory(atPath: resourcePath)
            let pngFiles = contents.filter { $0.hasSuffix(".png") }
            return pngFiles
        } catch {
            print("Error reading contents of resource path: \(error.localizedDescription)")
        }
        
        return nil;
    }

}
