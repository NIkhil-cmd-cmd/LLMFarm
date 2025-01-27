//
//  ChatListView.swift
//  ChatUI
//
//  Created by Shezad Ahamed on 05/08/21.
//

import SwiftUI

struct ChatListView: View {
    @EnvironmentObject var fineTuneModel: FineTuneModel
    @EnvironmentObject var aiChatModel: AIChatModel
    
    @State var searchText: String = ""
    @Binding var tabSelection: Int
    @Binding var model_name: String
    @Binding var title: String
    @Binding var add_chat_dialog: Bool
    var close_chat: () -> Void
    @Binding var edit_chat_dialog: Bool
    @Binding var chat_selection: Dictionary<String, String>?
    @Binding var after_chat_edit: () -> Void 
    @State var chats_previews:[Dictionary<String, String>] = []
    @State var current_detail_view_name:String? = "Chat"
    @State private var toggleSettings = false
    @State private var toggleAddChat = false
    
    func refresh_chat_list(){
        if is_first_run(){
            create_demo_chat()
        }
        self.chats_previews = get_chats_list() ?? []
        aiChatModel.update_chat_params()
    }
    
    func Delete(at offsets: IndexSet) {
        let chatsToDelete = offsets.map { self.chats_previews[$0] }
        _ = deleteChats(chatsToDelete)
        refresh_chat_list()
    }
    
    func Delete(at elem:Dictionary<String, String>){
        _ = deleteChats([elem])
        self.chats_previews.removeAll(where: { $0 == elem })
        refresh_chat_list()
    }
    
    func Duplicate(at elem:Dictionary<String, String>){
        _ = duplicateChat(elem)
        refresh_chat_list()
    }
    
    var body: some View {
        ZStack {
            DarkGradientBackground()
            
            VStack(alignment: .leading, spacing: 5){
                
                Text("Welcome to the other side of language models: SLM (small language models). Generate random outputs and messages, try out different on-device models with RAG, chat with a variety of different models.")
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.8))
                    .padding(.horizontal)
                    .padding(.bottom, 10)
                
                VStack(){
                    List(selection: $chat_selection){
                        ForEach(chats_previews, id: \.self) { chat_preview in
                            NavigationLink(value: chat_preview){
                                ChatItem(
                                    chatImage: String(describing: chat_preview["icon"]!),
                                    chatTitle: String(describing: chat_preview["title"]!),
                                    message: String(describing: chat_preview["message"]!),
                                    time: String(describing: chat_preview["time"]!),
                                    model:String(describing: chat_preview["model"]!),
                                    chat:String(describing: chat_preview["chat"]!),
                                    model_size:String(describing: chat_preview["model_size"]!),
                                    model_name: $model_name,
                                    title: $title,
                                    close_chat:close_chat
                                )
                                .listRowInsets(.init())
                                .contextMenu {
                                    Button(action: {
                                        Duplicate(at: chat_preview)
                                    }){
                                        Text("Duplicate chat")
                                    }
                                    Button(action: {
                                        Delete(at: chat_preview)
                                    }){
                                        Text("Remove chat")
                                    }
                                }
                            }
                        }
                        .onDelete(perform: Delete)
                    }
                    .frame(maxHeight: .infinity)
#if os(macOS)
                    .listStyle(.sidebar)
#else
                    .listStyle(InsetListStyle())
#endif
                }
                .background(.opacity(0))
                
                if chats_previews.count<=0{
                    VStack{
                        Button {
                            Task {
                                toggleAddChat = true
                                add_chat_dialog = true
                                edit_chat_dialog = false
                            }
                        } label: {
                            Image(systemName: "plus.square.dashed")
                                .foregroundColor(.secondary)
                                .font(.system(size: 40))
                        }
                        .buttonStyle(.borderless)
                        .controlSize(.large)
                        Text("Start new chat")
                            .font(.title3)
                            .frame(maxWidth: .infinity)
                        
                    }.opacity(0.4)
                        .frame(maxWidth: .infinity,alignment: .center)
                }
            }.task {
                after_chat_edit = refresh_chat_list
                refresh_chat_list()
            }
            .navigationTitle("Solo Chat")
            .sheet(isPresented: $toggleSettings) {
                AppSettingsView(current_detail_view_name:$current_detail_view_name).environmentObject(fineTuneModel)
#if os(macOS)
                    .frame(minWidth: 400,minHeight: 600)
#endif
            }
            .sheet(isPresented: $toggleAddChat) {
                if edit_chat_dialog{
                    ChatSettingsView(add_chat_dialog: $toggleAddChat,
                                edit_chat_dialog: $edit_chat_dialog,
                                chat_name: aiChatModel.chat_name,
                                after_chat_edit: $after_chat_edit,
                                toggleSettings: $toggleSettings).environmentObject(aiChatModel)
#if os(macOS)
                        .frame(minWidth: 400,minHeight: 600)
#endif
                }else{
                    ChatSettingsView(add_chat_dialog: $toggleAddChat,
                                edit_chat_dialog: $edit_chat_dialog,
                                after_chat_edit: $after_chat_edit,
                                toggleSettings: $toggleSettings).environmentObject(aiChatModel)
#if os(macOS)
                        .frame(minWidth: 400,minHeight: 600)
#endif
                }
            }
            
            // Floating Action Button
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        Task {
                            add_chat_dialog = true
                            edit_chat_dialog = false
                            toggleAddChat = true
                        }
                    } label: {
                        Image(systemName: "bubble.and.pencil.rtl")
                            .font(.title3.bold())
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(
                                LinearGradient(
                                    gradient: Gradient(colors: [.purple.opacity(0.8), .purple.opacity(0.4)]),
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                            .clipShape(Circle())
                            .shadow(radius: 3)
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 20)
                }
            }
        }
    }
}

struct RadialGradientBackground: View {
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            // Increased opacity for blue gradient
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.5),
                    Color.clear
                ]),
                center: .topLeading,
                startRadius: 0,  // Reduced start radius
                endRadius: 600   // Increased end radius
            )
            .edgesIgnoringSafeArea(.all)
            
            // Increased opacity for green gradient
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.purple.opacity(0.4),
                    Color.clear
                ]),
                center: .topTrailing,
                startRadius: 0,  // Reduced start radius
                endRadius: 600   // Increased end radius
            )
            .edgesIgnoringSafeArea(.all)
            
            // Increased opacity for purple gradient
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.purple.opacity(0.4),
                    Color.clear
                ]),
                center: .bottomTrailing,
                startRadius: 0,  // Reduced start radius
                endRadius: 500   // Increased end radius
            )
            .edgesIgnoringSafeArea(.all)
        }
    }
}


