//
//  ContentView.swift
//  BetMate
//
//  Created by Nick Viamin on 7/23/23.
//

import SwiftUI

struct ContentView: View {
    @State private var amt = ""
    @State private var showErrorAlert = false
    
    // Results
    @State private var bets: [Bet] = [Bet(odds: "")]
    @State private var potentialPayout = ""
    @State private var profitLoss = ""
    @State private var impliedProbability = ""
    @State private var totalPayout = ""
    
    var body: some View {
        VStack {
            Text("BetMate")
                .font(Font.custom(FontsManager.Fonts.treb, size: 30))
                .bold()
                .padding()
            InputField(imageName: "dollarsign", placeholderText: "Amount Bet", text: $amt)
            ScrollView {
                ForEach(bets.indices, id: \.self) { index in
                    HStack {
                        Text("Leg \(index+1)")
                            .font(Font.custom(FontsManager.Fonts.treb, size: 20))
                            .bold()
                            .padding()
                        InputField(imageName: "plus.forwardslash.minus", placeholderText: "Odds", text: $bets[index].odds)
                    }
                }
            }
            HStack {
                Spacer()
                Button(action: addBet) {
                    Image(systemName: "plus")
                        .foregroundColor(.green)
                        .font(.system(size: 30))
                }
                Spacer()
                Button(action: deleteLastBet) {
                    Image(systemName: "minus")
                        .foregroundColor(.red)
                        .font(.system(size: 30))
                }
                Spacer()
            }
            .padding(.top, 8)
            
            if !potentialPayout.isEmpty && !impliedProbability.isEmpty && !totalPayout.isEmpty {
                VStack {
                    Text("Results:")
                        .font(.headline)
                        .padding()
                    Text("Total Payout: $\(totalPayout)")
                    Text("Profit: $\(potentialPayout)")
                    Text("Implied Probability: \(impliedProbability)%")
                    
                }
            }
            
            Button {
                calculateParlay()
            } label: {
                if bets.count == 1 {
                    Text("Calculate")
                        .font(Font.custom(FontsManager.Fonts.treb, size: 20))
                        .foregroundColor(.white)
                        .frame(width: 340, height: 50)
                        .background(Color(red: 251 / 255, green: 143 / 255, blue: 104 / 255))
                        .clipShape(Capsule())
                        .padding()
                } else if bets.count > 1 {
                    Text("Calculate Parlay")
                        .font(Font.custom(FontsManager.Fonts.treb, size: 20))
                        .foregroundColor(.white)
                        .frame(width: 340, height: 50)
                        .background(Color(red: 251 / 255, green: 143 / 255, blue: 104 / 255))
                        .clipShape(Capsule())
                        .padding()
                } else {
                    Text("Press the + Sign to Add a Bet")
                        .font(Font.custom(FontsManager.Fonts.treb, size: 20))
                        .foregroundColor(.white)
                        .frame(width: 340, height: 50)
                        .background(Color(red: 251 / 255, green: 143 / 255, blue: 104 / 255))
                        .clipShape(Capsule())
                        .padding()
                }
            }
            Spacer()
        }
        .alert(isPresented: $showErrorAlert, content: {
            Alert(title: Text("Error"), message: Text("Invalid input for odds. Only numbers greater than +99 or less than -100, +, or - are allowed."), dismissButton: .default(Text("OK")))
        })
        .padding()
    }
    
    private func addBet() {
        bets.append(Bet(odds: ""))
    }
    
    private func deleteLastBet() {
        bets.popLast()
    }
    
    private func calculateParlay() {
        var potentialPayoutValue = 0.0
        var totalPayoutValue = 0.0
        var impliedProbabilityValue = 1.0
        var totalBetValue = 0.0
        if let totalBet = Double(amt) {
            totalBetValue = totalBet
        } else {
            // Handle invalid input for the total bet (non-numeric value or nil)
            return
        }

        for bet in bets {
            guard let oddsValue = Double(bet.odds) , oddsValue > 99 || oddsValue < -100  else {
                showErrorAlert = true
                return
            }
            impliedProbabilityValue *= oddsValue < 0 ? (-1 * oddsValue) / (-1 * oddsValue + 100) : (100 / (oddsValue + 100))
        }
        totalPayoutValue = totalBetValue * (1/impliedProbabilityValue)
        potentialPayoutValue =  totalPayoutValue - totalBetValue // Add potentialPayoutValue to totalPayoutValue
        potentialPayout = String(format: "%.2f", potentialPayoutValue)
        totalPayout = String(format: "%.2f", totalPayoutValue)
        impliedProbability = String(format: "%.2f", impliedProbabilityValue * 100)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct Bet: Identifiable {
    let id = UUID()
    var odds: String
}
