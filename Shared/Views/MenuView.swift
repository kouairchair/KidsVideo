//
//  MenuView.swift
//  KidsVideo
//
//  TCA Menu View - Replaces ContentView with TCA integration
//

import SwiftUI
import ComposableArchitecture
import CoreData
import AVFAudio

public struct MenuView: View {
    let store: StoreOf<MenuFeature>
    private var columns: [GridItem] = Array(repeating: .init(.adaptive(minimum: 250, maximum: 280), spacing: CGFloat(30.0) ), count: 3)
    
    init(store: StoreOf<MenuFeature>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                // Background image
                Image(viewStore.backgroundImageName)
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                    .opacity(0.2)
                
                // Content
                ScrollView(.vertical) {
                    LazyVGrid(columns: columns, alignment: .center, spacing: 20) {
                        ForEach(viewStore.menuImages) { menuImage in
                            MenuCellView(
                                menuImage: menuImage,
                                isAnimating: viewStore.isAnimating,
                                onTap: {
                                    viewStore.send(.didTapChannel(menuImage.channel))
                                }
                            )
                        }
                    }
                    
#if targetEnvironment(macCatalyst)
                    // macOS環境でのみアプリ全体の明るさを調整できるようにする
                    Spacer()
                    Slider(
                        value: viewStore.binding(
                            get: \.currentAlphaValue,
                            send: MenuFeature.Action.changeBrightness
                        ),
                        in: 1...10
                    )
                    .frame(width: 500, alignment: .center)
#endif
                }
            }
            .navigationBarHidden(true)
            .onAppear {
                viewStore.send(.onAppear)
            }
            .onDisappear {
                viewStore.send(.onDisappear)
            }
            .onReceive(NotificationCenter.default.publisher(for: Notification.Name.backToMenuNotification)) { _ in
                viewStore.send(.backToMenuNotificationReceived)
            }
        }
    }
}

struct MenuCellView: View {
    let menuImage: MenuImage
    let isAnimating: Bool
    var onTap: () -> Void

    var body: some View {
        if let image = menuImage.image {
            VStack {
                Button(action: onTap) {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 280, height: 280)
                        .clipShape(Circle())
                        .wiggle(isActive: isAnimating)
                }
                .buttonStyle(PlainButtonStyle())
                
                Text(menuImage.fileName)
                    .font(.custom("KiwiMaru-Light", size: 22))
            }
        }
    }
}

#Preview {
    MenuView(store: Store(initialState: MenuFeature.State()) {
        MenuFeature()
    })
}
