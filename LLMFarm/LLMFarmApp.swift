//
//  LLMFarmApp.swift
//  LLMFarm
//
//  Created by guinmoon on 20.05.2023.
//

import SwiftUI
import Darwin
//import llmfarm_core_cpp

@main
struct LLMFarmApp: App {
    @Environment(\.colorScheme) var colorScheme
    
    var body: some Scene {
        WindowGroup {
            MainTabView()
                .accentColor(.purple)
                .preferredColorScheme(.dark)
        }
    }
}

struct MainTabView: View {
    @StateObject var aiChatModel = AIChatModel()
    @StateObject var fineTuneModel = FineTuneModel()
    @StateObject var orientationInfo = OrientationInfo()
    @Environment(\.colorScheme) var colorScheme
    
    @State private var selectedTab = 0
    @State var add_chat_dialog = false
    @State var edit_chat_dialog = false
    @State var model_name = ""
    @State var title = ""
    @State var chat_selection: Dictionary<String, String>?
    @State var current_detail_view_name: String? = "Chat"
    @State var after_chat_edit: () -> Void = {}
    @State private var navigationPath = NavigationPath()
    
    // Define your tabs
    enum Tab: Int {
        case chats = 0
        case models
        case about
    }
    
    var body: some View {
        ZStack {
           

            
            VStack {
                // Content based on selected tab
                ZStack {
                    switch Tab(rawValue: selectedTab) {
                    case .chats:
                        NavigationSplitView {
                            ChatListView(
                                tabSelection: .constant(selectedTab),
                                model_name: $model_name,
                                title: $title,
                                add_chat_dialog: $add_chat_dialog,
                                close_chat: close_chat,
                                edit_chat_dialog: $edit_chat_dialog,
                                chat_selection: $chat_selection,
                                after_chat_edit: $after_chat_edit
                            )
                            .environmentObject(fineTuneModel)
                            .environmentObject(aiChatModel)
                            .environmentObject(orientationInfo)
                            .frame(minWidth: 250, maxHeight: .infinity)
                        } detail: {
                            ChatView(
                                modelName: $model_name,
                                chatSelection: $chat_selection,
                                title: $title,
                                CloseChat: close_chat,
                                AfterChatEdit: $after_chat_edit,
                                addChatDialog: $add_chat_dialog,
                                editChatDialog: $edit_chat_dialog
                            )
                            .environmentObject(aiChatModel)
                            .environmentObject(orientationInfo)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        }
                        .navigationSplitViewStyle(.balanced)
                    
                    case .models:
                        NavigationView {
                            AppSettingsView(current_detail_view_name: $current_detail_view_name)
                                .environmentObject(fineTuneModel)
                        }
                    
                    case .about:
                        NavigationView {
                            About()
                        }
                    
                    default:
                        EmptyView()
                    }
                }
                
                Spacer()
                
                // Custom Floating Tab Bar
                CustomTabBar(selectedTab: $selectedTab)
                    .padding(.bottom, 20) // Adjust as needed
            }
        }
        .ignoresSafeArea()
        .onAppear {
            let appearance = UITabBarAppearance()
            appearance.backgroundEffect = UIBlurEffect(style: .dark)
            appearance.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            
            UITabBar.appearance().standardAppearance = appearance
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }

    func close_chat() -> Void {
        aiChatModel.stop_predict()
    }
}

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    // Define your tabs with icons and titles
    private let tabs: [TabItem] = [
        TabItem(icon: "bubble.left.and.bubble.right", title: "Chats"),
        TabItem(icon: "shippingbox.fill", title: "Models"),
        TabItem(icon: "info.circle", title: "About")
    ]
    
    var body: some View {
        HStack {
            ForEach(0..<tabs.count, id: \.self) { index in
                Spacer()
                
                Button(action: {
                    withAnimation {
                        selectedTab = index
                    }
                }) {
                    VStack {
                        Image(systemName: tabs[index].icon)
                            .font(.system(size: 20, weight: .semibold))
                        Text(tabs[index].title)
                            .font(.caption)
                    }
                    .foregroundColor(selectedTab == index ? .purple : .gray)
                }
                
                Spacer()
            }
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 10)
        .background(
            ZStack {
                Color.black
                    .opacity(0.8)
                RoundedRectangle(cornerRadius: 25)
                    .strokeBorder(
                        LinearGradient(
                            gradient: Gradient(colors: [.purple, .blue]),
                            startPoint: .leading,
                            endPoint: .trailing
                        ),
                        lineWidth: 2
                    )
            }
        )
        .cornerRadius(25)
        .shadow(color: Color.purple.opacity(0.3), radius: 10, x: 0, y: 5)
        .padding(.horizontal, 20)
    }
}

struct TabItem {
    let icon: String
    let title: String
}

struct CustomTabBar_Previews: PreviewProvider {
    static var previews: some View {
        CustomTabBar(selectedTab: .constant(0))
            .previewLayout(.sizeThatFits)
            .preferredColorScheme(.dark)
    }
}
