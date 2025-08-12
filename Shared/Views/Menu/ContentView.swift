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
    @State private var currentAlphaValue: Double = 3
    
    // Get background image from configuration
    private var backgroundImageName: String {
        if let configuration = ChildConfigurationManager.loadConfiguration() {
            return configuration.backgroundImage
        }
        // Fallback to default
        return "menu_background_image_jinan"
    }
      
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    // Use a static/shared player to prevent multiple instances
    static var sharedBDPlayer: AVAudioPlayer?

    var body: some View {
        EmptyView()
//        NavigationView {
//            ZStack {
//                // Background image
//                Image(backgroundImageName)
//                    .resizable()
//                    .scaledToFill()
//                    .ignoresSafeArea()
//                    .opacity(0.2)
//                
//                // Content
//                ScrollView(.vertical) {
//                    LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
//                        ForEach(menuImages) { menuImage in
//                            MenuCellView(menuImage: menuImage, isAnimating: isAnimating, onTap: {
//                                ContentView.sharedBDPlayer?.stop()
//                            })
//                        }
//                    }
//                    .onAppear {
//                        isAnimating = true
//                    }
//#if targetEnvironment(macCatalyst)
//                    // macOS環境でのみアプリ全体の明るさを調整できるようにする
//                    Spacer()
//                    Slider(value: $currentAlphaValue,
//                           in: 1...10,
//                           onEditingChanged: { _ in
//                               changeBrightness()
//                           })
//                        .frame(width: 500, alignment: .center)
//#endif
//                }
//            }
//        }
//        .navigationViewStyle(StackNavigationViewStyle())
//        .navigationBarHidden(true)
//        .onAppear {
//            // Stop any existing player before creating/playing a new one
//            ContentView.sharedBDPlayer?.stop()
//            do {
//                ContentView.sharedBDPlayer = try AVAudioPlayer(contentsOf: MusicMaker.getTodayMusic().fileUrl!)
//                ContentView.sharedBDPlayer?.play()
//            } catch {
//                print("Couldn't play audio. Error: \(error)")
//            }
//        }
//        .onDisappear {
//            // Stop music when leaving the menu
//            ContentView.sharedBDPlayer?.stop()
//        }
//        .onReceive(NotificationCenter.default.publisher(for: Notification.Name.backToMenuNotification)) { _ in
//            ContentView.sharedBDPlayer?.play()
//        }
    }
    
    private func changeBrightness() {
        let keyWindow: UIWindow?
        
        if #available(iOS 15.0, *) {
            keyWindow = UIApplication.shared.connectedScenes
                .filter({$0.activationState == .foregroundActive})
                .map({$0 as? UIWindowScene})
                .compactMap({$0})
                .first?.keyWindow
        } else {
            // Fallback for older iOS versions
            keyWindow = UIApplication.shared.windows.first(where: { $0.isKeyWindow })
        }
        
        guard let window = keyWindow else {
            print("Warning: Could not get key window, skipping brightness adjustment")
            return
        }
        
        window.alpha = currentAlphaValue * 0.1
    }
}

//struct MenuCellView: View {
//    let menuImage: MenuImage
//    let isAnimating: Bool
//    var onTap: () -> Void
//
//    var body: some View {
//        if let image = menuImage.image {
//            VStack {
//                NavigationLink(destination: PlayerViewControllerWrapper(selectedChannel: menuImage.channel, action: onTap)) {
//                    Image(uiImage: image)
//                        .resizable()
//                        .aspectRatio(contentMode: .fill)
//                        .frame(width: 280, height: 280)
//                        .clipShape(Circle())
//                        .wiggle(isActive: isAnimating)
//                }
//                
//                Text(menuImage.fileName)
//                    .font(.custom("KiwiMaru-Light", size: 22))
//            }
//        }
//    }
//}
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
