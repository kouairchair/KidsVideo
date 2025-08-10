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
    @State private var currentAlphaValue: Double = 3
      
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>

    var body: some View {
        NavigationView {
            ZStack {
                // Background image
                Image("menu_background_image_ryoma")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .opacity(0.2)
                
                // Content
                ScrollView(.vertical) {
                    LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                        ForEach(menuImages) { menuImage in
                            MenuCellView(menuImage: menuImage, isAnimating: isAnimating, onNavigate: {
                                self.BDPlayer?.stop()
                            })
                        }
                    }
                    .onAppear {
                        isAnimating = true
                    }
#if targetEnvironment(macCatalyst)
                    // macOS環境でのみアプリ全体の明るさを調整できるようにする
                    Spacer()
                    Slider(value: $currentAlphaValue,
                           in: 1...10,
                           onEditingChanged: { _ in
                               changeBrightness()
                           })
                        .frame(width: 500, alignment: .center)
#endif
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle())
        .navigationBarHidden(true)
        .onAppear {
            do {
                // Delaying brightness change slightly to ensure the window is available.
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    adjustBrightnessForAllScreens()
                }
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
        .onReceive(NotificationCenter.default.publisher(for: UIScreen.didConnectNotification)) { _ in
            // External screen connected - adjust brightness for all screens
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                adjustBrightnessForAllScreens()
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIScreen.didDisconnectNotification)) { _ in
            // External screen disconnected - readjust brightness
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                adjustBrightnessForAllScreens()
            }
        }
    }
    
    private func adjustBrightnessForAllScreens() {
        if #available(iOS 15.0, *) {
            // Handle all active window scenes
            for scene in UIApplication.shared.connectedScenes {
                if let windowScene = scene as? UIWindowScene,
                   scene.activationState == .foregroundActive {
                    for window in windowScene.windows {
                        if window.isKeyWindow {
                            adjustWindowBrightness(window: window)
                        }
                    }
                }
            }
        } else {
            // Fallback for older iOS versions
            for window in UIApplication.shared.windows {
                if window.isKeyWindow {
                    adjustWindowBrightness(window: window)
                }
            }
        }
    }
    
    private func adjustWindowBrightness(window: UIWindow) {
        // Only apply brightness adjustment if this is the main device screen
        // External monitors should maintain full brightness for proper visibility
        if isMainDeviceScreen(window: window) {
            window.alpha = currentAlphaValue * 0.1
            print("Main device screen - applying brightness adjustment: \(window.alpha)")
        } else {
            // Ensure external monitors maintain full opacity
            window.alpha = 1.0
            print("External monitor detected - maintaining full brightness")
        }
    }
    
    private func changeBrightness() {
        adjustBrightnessForAllScreens()
    }
    
    private func isMainDeviceScreen(window: UIWindow) -> Bool {
        // Check if this window is on the main device screen
        guard let windowScene = window.windowScene else { return true }
        
        // Check if this is the main screen by object identity (most reliable)
        if windowScene.screen === UIScreen.main {
            return true
        }
        
        // Fallback: For external displays, the screen bounds will be different from the main screen
        let mainScreenBounds = UIScreen.main.bounds
        let windowScreenBounds = windowScene.screen.bounds
        
        // If the screen bounds match the main screen, it's likely the main device
        return mainScreenBounds.size == windowScreenBounds.size
    }
}

struct MenuCellView: View {
    let menuImage: MenuImage
    let isAnimating: Bool
    var onNavigate: () -> Void

    var body: some View {
        if let image = menuImage.image {
            VStack {
                NavigationLink(destination: PlayerViewControllerWrapper(selectedChannel: menuImage.channel, action: onNavigate)) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 280, height: 280)
                        .clipShape(Circle())
                        .wiggle(isActive: isAnimating)
                }
                
                Text(menuImage.fileName)
                    .font(.custom("KiwiMaru-Light", size: 22))
            }
        }
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
