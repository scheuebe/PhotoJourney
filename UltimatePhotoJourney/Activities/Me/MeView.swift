//
//  MeView.swift
//  UltimatePhotoJourney
//
//  Created by Bernhard Scheuermann on 11.02.22.
//

import SwiftUI

struct MeView: View {
    static let tag: String? = "Me"

    @State var isPinned = false
    @State var isDeleted = false
    
    @State var countriesVisited: [String] = []
    
    @FetchRequest(sortDescriptors: []) var albums: FetchedResults<Album>
    @FetchRequest(sortDescriptors: []) var items: FetchedResults<Item>

    @Environment(\.presentationMode) var presentationMode
    @Environment(\.horizontalSizeClass) private var horizontalSizeClass
    @AppStorage("isLogged") var isLogged = false
    @AppStorage("name") var name = ""
    @State var address: Address = Address(id: 1, country: "Canada")
    
    var columns: [GridItem] {
        [GridItem(.adaptive(minimum: 60, maximum: 60))]
    }

    var body: some View {
        NavigationView {
            List {
                Section {
                    profile
                }

                linksSection

                Section(header: Text("Awards")) {
                        AwardsView()
                }

                Section(header: Text("Statistics")) {
                    HStack {
                        Text("Countries you have visited (BETA):")
                        Spacer()
                        Text("5")
                        //Text("\(countriesVisited.count/(albums.count*2))")
                    }
                    .opacity(0.4)

                    HStack {
                        Text("Kilometers traveled (BETA):")
                        Spacer()
                        Text("1.703 km")
                    }
                    .opacity(0.4)

                    HStack {
                        Text("Number of albums:")
                        Spacer()
                        Text("\(albums.count)")
                    }

                    HStack {
                        Text("Number of photos:")
                        Spacer()
                        Text("\(items.count)")
                    }
                }

                // maybe add 'onTapGesture' with the flag name in the device language
                Section(header: Text("Flags collected (Coming soon)"),
                        footer: Spacer().frame(height: 55)) {
                    /*HStack {
                        ForEach(countriesVisited, id: \.self) { country in
                            //Button {
                                
                            //} label: {
                                Image("\(country.lowercased())")
                                    .resizable()
                                    .cornerRadius(4)
                                    .frame(width: 48, height: 36)
                            //}
                            //.buttonStyle(BorderlessButtonStyle())
                            //.accessibilityLabel(label(for: award))
                            //.accessibility(hint: Text(award.description))
                        }
                    }*/
                    
                     HStack {
                        Image("at")
                            .resizable()
                            .cornerRadius(4)
                            .frame(width: 48, height: 36)
                            .overlay(RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.black.opacity(0.7), lineWidth: 1))
                            //.shadow(radius: 10)
                        Image("be")
                            .resizable()
                            .cornerRadius(4)
                            .frame(width: 48, height: 36)
                            .overlay(RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.black.opacity(0.7), lineWidth: 1))
                        Image("ch")
                            .resizable()
                            .cornerRadius(4)
                            .frame(width: 48, height: 36)
                            .overlay(RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.black.opacity(0.7), lineWidth: 1))
                        Image("de")
                            .resizable()
                            .cornerRadius(4)
                            .frame(width: 48, height: 36)
                            .overlay(RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.black.opacity(0.7), lineWidth: 1))
                        Image("gb")
                            .resizable()
                            .cornerRadius(4)
                            .frame(width: 48, height: 36)
                            .overlay(RoundedRectangle(cornerRadius: 4)
                                .stroke(Color.black.opacity(0.7), lineWidth: 1))
                    }
                     .padding(.vertical, 12)
                     .opacity(0.4)
                }

                
                // future work
                /*
                 Section(header: Text("Continents visited"),
                        footer: Spacer().frame(height: 15)) {
                    EmptyView()
                }
                 */

                /*
                 Button {} label: {
                    Text("Sign out")
                        .frame(maxWidth: .infinity)
                }
                .tint(.red)
                .onTapGesture {
                    isLogged = false
                    presentationMode.wrappedValue.dismiss()
                }
                 */
            }
            .listStyle(.insetGrouped)
            .navigationBarHidden(true)
            // .navigationTitle("Me")
            .task {
                await fetchAddress()
            }
            .refreshable {
                await fetchAddress()
            }
        }
        .navigationViewStyle(.stack)
        .onAppear {
            countCountries()
        }
    }

    var linksSection: some View {
        Section(header: Text("Socials")) {
            if !isDeleted {
                Link(destination: URL(string: "https://uni-augsburg.de/")!) {
                    HStack {
                        Image(systemName: "house")
                            .foregroundColor(.appColor)
                        Text("Website")
                            .tint(.primary)
                        Spacer()
                        Image(systemName: "link")
                            .tint(.appColor.opacity(0.5))
                    }
                }
                .swipeActions(edge: .leading) {
                    Button {
                        withAnimation {
                            isPinned.toggle()
                        }
                    } label: {
                        if isPinned {
                            Label("Unpin", systemImage: "pin.slash")
                        } else {
                            Label("Pin", systemImage: "pin")
                        }
                    }
                    .tint(isPinned ? .gray : .yellow)
                }
                .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                    Button {
                        withAnimation {
                            isDeleted.toggle()
                        }
                    } label: {
                        Label("Delete", systemImage: "trash")
                    }
                    .tint(.red)
                }
            }

            Link(destination: URL(string: "https://uni-augsburg.de/")!) {
                HStack {
                    Image(systemName: "tv")
                        .foregroundColor(.appColor)
                    Text("YouTube")
                        .tint(.primary)
                    Spacer()
                    Image(systemName: "link")
                        .tint(.appColor.opacity(0.5))
                }
            }
        }
        .listRowSeparator(.automatic)
    }

    var profile: some View {
        VStack {
            Image(systemName: "person.crop.circle.fill.badge.checkmark")
                .symbolVariant(.circle.fill)
                .symbolRenderingMode(.palette)
                .foregroundStyle(.orange, .orange.opacity(0.8), .red)
                .font(.system(size: 32))
                .padding()
                .background(Circle().fill(.ultraThinMaterial))
                .background(AnimatedBlobView().frame(width: 400, height: 414).offset(x: 200, y: 0).scaleEffect(0.5))
                .background(HexagonView().offset(x: -50, y: -100))
            
            TextField("Enter your name", text: $name)
                .font(.title.weight(.semibold))
                .foregroundColor(.primary.opacity(0.8))
                .multilineTextAlignment(.center)
                
            Text(address.country)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
        .padding()
    }

    func fetchAddress() async {
        do {
            let url = URL(string: "https://random-data-api.com/api/address/random_address")!
            let (data, _) = try await URLSession.shared.data(from: url)
            address = try JSONDecoder().decode(Address.self, from: data)
        } catch {
            address = Address(id: 1, country: "Error fetching")
        }
    }
    
    func countCountries() {
        for item in items {
            if !countriesVisited.contains(item.isoCountry ?? "") {
                countriesVisited.append(item.isoCountry ?? "de")
            }
        }
        print(countriesVisited)
    }
}

struct MeView_Previews: PreviewProvider {
    static var previews: some View {
        MeView()
    }
}

struct Address: Identifiable, Decodable {
    var id: Int
    var country: String
}
