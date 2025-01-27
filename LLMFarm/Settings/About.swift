//
//  About.swift
//  LLMFarm
//
//  Created by guinmoon on 20.10.2024.
//

import SwiftUI

struct About: View {
    let app_version = Bundle.main.infoDictionary!["CFBundleShortVersionString"] as! String
    
    var body: some View {
        ZStack {
            DarkGradientBackground()
            
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    // Header
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Solo")
                            .font(.largeTitle.bold())
                            .foregroundColor(.white)
                        
                        Text("Your Personal On-Device AI Assistant")
                            .font(.headline)
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.bottom)
                    
                    // Main Info
                    VStack(alignment: .leading, spacing: 12) {
                        InfoSection(
                            title: "On-Device Privacy",
                            description: "All processing happens locally on your device. No data is ever sent to external servers.",
                            icon: "lock.shield.fill"
                        )
                        
                        InfoSection(
                            title: "Powered by LLMFarm",
                            description: "Built on the robust LLMFarm framework for efficient local language model processing.",
                            icon: "cpu.fill"
                        )
                        
                        InfoSection(
                            title: "Offline First", 
                            description: "Works completely offline with no internet connection required.",
                            icon: "wifi.slash"
                        )
                    }
                    .frame(maxWidth: .infinity)
                    
                    // Links
                    Link(destination: URL(string: "https://getsolo.tech")!) {
                        HStack {
                            Image(systemName: "infinity")
                            Text("Get Solo Tech")
                            Spacer()
                            Image(systemName: "arrow.right")
                        }
                        .foregroundColor(.white)
                        .padding()
                        .background(Color.black.opacity(0.2))
                        .cornerRadius(8)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(.white.opacity(0.1), lineWidth: 1)
                        )
                    }
                    
                    Text("© 2024 Nikhil Krishnaswamy")
                        .font(.footnote)
                        .foregroundColor(.white.opacity(0.6))
                }
                .padding()
            }
        }
    }
}

struct DarkGradientBackground: View {
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.blue.opacity(0.15),
                    Color.clear
                ]),
                center: .topLeading,
                startRadius: 0,
                endRadius: 300
            )
            .edgesIgnoringSafeArea(.all)
            
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.purple.opacity(0.1),
                    Color.clear
                ]),
                center: .topTrailing,
                startRadius: 0,
                endRadius: 200
            )
            .edgesIgnoringSafeArea(.all)
            
            RadialGradient(
                gradient: Gradient(colors: [
                    Color.purple.opacity(0.1),
                    Color.clear
                ]),
                center: .bottomTrailing,
                startRadius: 0,
                endRadius: 400
            )
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct InfoSection: View {
    let title: String
    let description: String
    let icon: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.white)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.white.opacity(0.7))
            }
        }
        .padding()
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.black.opacity(0.2))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.white.opacity(0.1), lineWidth: 1)
        )
    }
}

struct TransparentGroupBox: GroupBoxStyle {
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            configuration.content
        }
        .background(Color.black.opacity(0.2))
        .cornerRadius(8)
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(.white.opacity(0.1), lineWidth: 1)
        )
    }
}

//#Preview {
//    About()
//}
