//
//  ContentView.swift
//  Shared
//
//  Created by headspinnerd on 2021/09/26.
//

import SwiftUI
import CoreData
import AVFAudio

struct ContentView: View {
    private let menuImages = MenuImageMaker.getImages()
    private var columns: [GridItem] = Array(repeating: .init(.adaptive(minimum: 250, maximum: 280), spacing: CGFloat(30.0) ), count: 3)
    @State var isAnimating: Bool = false
    @State var BDPlayer: AVAudioPlayer?
      
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            ScrollView(.vertical) {
                LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                    ForEach(menuImages) { menuImage in
                        if let image = menuImage.image {
                            VStack {
                                NavigationLink(destination: PlayerViewControllerWrapper(selectedChannel:menuImage.channel ,action: {
                                    self.BDPlayer?.stop()
                                })) {
                                    Image(uiImage: image)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 280, height: 280)
                                        .clipShape(Circle())
                                        .wiggle(isActive: isAnimating)
                                }
                                
                                Text(menuImage.fileName)
                                //TOOD: custom fontが適用されない！
                                    .font(.custom("PenguinAttack", size: 22))
                            }

                        }
                    }
                    .onAppear {
                        isAnimating = true
                    }
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .onAppear {
            do {
                try self.BDPlayer = AVAudioPlayer(contentsOf: MusicMaker.getTodayMusic().fileUrl!) /// make the audio player
                //self.BDPlayer?.volume = 5
                self.BDPlayer?.play()
            } catch {
                print("Couldn't play audio. Error: \(error)")
            }
        }
//        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
//
//        }
        .onReceive(NotificationCenter.default.publisher(for: Notification.Name.backToMenuNotification)) { _ in
            self.BDPlayer?.play()
        }
//            List {
//                ForEach(items) { item in
//                    NavigationLink(destination: Text("Item at \(item.timestamp!, formatter: itemFormatter)")) {
//                        Text(item.timestamp!, formatter: itemFormatter)
//                    }
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//#if os(iOS)
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//#endif
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
//            Text("Select an item")
//        }

//    private func addItem() {
//        withAnimation {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                // Replace this implementation with code to handle the error appropriately.
//                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
    }
}
//
//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    formatter.timeStyle = .medium
//    return formatter
//}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
