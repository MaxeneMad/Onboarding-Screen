//
//  ContentView.swift
//  OnboardingScreen
//
//  Created by Maxène Madouche on 10/02/2023.
//


import SwiftUI

class OnboardingData: ObservableObject {
    @Published var currentPage: Int = 1
    
    init() {
        if let storedPage = UserDefaults.standard.object(forKey: "currentPage") as? Int {
            currentPage = storedPage
        }
    }
    
    func updateCurrentPage(page: Int) {
        currentPage = page
        UserDefaults.standard.set(currentPage, forKey: "currentPage")
    }
}
struct ContentView: View {
    @ObservedObject var onboardingData = OnboardingData()
    
    let totalPages = 3

    var body: some View {
        if onboardingData.currentPage > totalPages {
            Home()
        } else {
            OnboardingScreen(onboardingData: onboardingData)
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Home: View {
    var body: some View {
        VStack {
            Text("Home Screen")
                .font(.title)
                .fontWeight(.heavy)
        }
    }
}


struct OnboardingScreen: View {
    @ObservedObject var onboardingData: OnboardingData
    @State private var offsetX: CGFloat = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                ScreenView(onboardingData: onboardingData, image: "first", title: "Start monetizing your content by converting your posts into NFTs")
                    .offset(x: offsetX)
                
                ScreenView(onboardingData: onboardingData, image: "second", title: "Puts your NFTs on the market for sale and start making money!")
                    .offset(x: offsetX + geometry.size.width)
                
                ScreenView(onboardingData: onboardingData, image: "third", title: "Join the new web3 social media!")
                    .offset(x: offsetX + 2 * geometry.size.width)
            }
            .frame(width: geometry.size.width, height: geometry.size.height, alignment: .leading)
            .onReceive(onboardingData.$currentPage) { newPage in
                withAnimation(.easeInOut(duration: 0.2)) {
                    offsetX = -CGFloat(newPage - 1) * geometry.size.width
                }
            }
        }
    }
}


struct ScreenView: View {
    @ObservedObject var onboardingData: OnboardingData
    
    var image: String
    var title: String
    
    var body: some View {
        VStack {
            HStack {
                if onboardingData.currentPage == 1 {
                    Text("")
                        .font(.title)
                        .fontWeight(.semibold)
                        .kerning(1.4)
                } else {
                    Button(action: {
                        onboardingData.updateCurrentPage(page: onboardingData.currentPage - 1)
                    }, label: {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                            .padding(.vertical, 10)
                            .padding(.horizontal)
                            .background(Color.black.opacity(0.4))
                            .cornerRadius(10)
                    })
                }
                
                Spacer()
                
                Button(action: {
                    onboardingData.updateCurrentPage(page: 4)
                }, label: {
                    Text("Skip")
                        .fontWeight(.semibold)
                        .kerning(1.2)
                })
            }.padding()
                .foregroundColor(.black)
            
            Spacer(minLength: 0)
            
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(.horizontal, 16)
                .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: 500, alignment: .center)
            
            Spacer(minLength: 25)
            
            Text(title)
                .font(.system(size: UIFontMetrics.default.scaledValue(for: 27)))
                .fontWeight(.semibold)
                .kerning(1)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 20)
                .fixedSize(horizontal: false, vertical: true)
            
            Spacer(minLength: 25)
            
            HStack(spacing: 8) {
                ForEach(1...3, id: \.self) { index in
                    Circle()
                        .frame(width: 30 / UIScreen.main.scale, height: 30 / UIScreen.main.scale)
                        .foregroundColor(onboardingData.currentPage == index ? .red : .gray)
                }
            }
            .padding(.horizontal, 100)
            
            Spacer(minLength: 25)
            
            if onboardingData.currentPage == 3 {
                Button(action: {
                    onboardingData.updateCurrentPage(page: onboardingData.currentPage + 1)
                }, label: {
                    Text("GET STARTED")
                        .fontWeight(.semibold)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(.red))
                        .cornerRadius(40)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                })
            } else {
                Button(action: {
                    onboardingData.updateCurrentPage(page: onboardingData.currentPage + 1)
                }, label: {
                    Text("NEXT")
                        .fontWeight(.semibold)
                        .frame(minWidth: 0, maxWidth: .infinity)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color(.red))
                        .cornerRadius(40)
                        .padding(.horizontal, 16)
                        .padding(.bottom, 20)
                })
            }
        }
    }
}
