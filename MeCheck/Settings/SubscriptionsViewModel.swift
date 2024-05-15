//
//  SubscriptionsViewModel.swift
//  MeCheck
//
//  Created by Robert Mutai on 01/05/2024.
//

import Foundation
import StoreKit

@MainActor
class SubscriptionsViewModel: NSObject, ObservableObject {
  
   
    let monthlyProductID: String = "mecheck.monthly"
    let annualProductID: String = "mecheck.annual"
    let lifetimeProductID: String = "mecheck.lifetime"
    var productIDs: [String] = []
    @Published var purchasedProduct: Set<PurchaseItem> = []
    let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd, YYYY"
        return formatter
    }()
    let features: [String] = [String(localized: "Remove all ads"), String(localized: "Unlimited habits"), String(localized: "Unlimited gratitude journal entries"), String(localized: "Unlock all charts"), String(localized: "Unlimited reminders")]

    @Published var products: [Product] = []
    private var entitlementManager: EntitlementManager? = nil
    private var updates: Task<Void, Never>? = nil
    
    init(entitlementManager: EntitlementManager) {
        self.entitlementManager = entitlementManager
        productIDs = [monthlyProductID, annualProductID, lifetimeProductID]
        super.init()
        self.updates = observeTransactionUpdates()
        SKPaymentQueue.default().add(self)
    }
    
    deinit {
        updates?.cancel()
    }
    
    func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await _ in Transaction.updates {
                await self.updatePurchasedProducts()
            }
        }
    }
    
    func calculateMonthly (price: Decimal) -> (newMonthPrice: String, saving:String, currentMonthPrice:String) {
        var newPrice = price/12.0
        var newPriceRounded = Decimal()
        NSDecimalRound(&newPriceRounded, &newPrice, 2, .down)
       
        guard let monthPrice: Decimal =  products.first(where: {$0.id == monthlyProductID})?.price else {
            
            return ("","","")
        }
        
        var saving = newPrice/monthPrice * 100
        var savingRounded = Decimal()
        NSDecimalRound(&savingRounded, &saving, 0, .down)
       
        return ("\(newPriceRounded)", "\(savingRounded)%","\(monthPrice)")
    }
}

// MARK: StoreKit2 API
extension SubscriptionsViewModel {
    func loadProducts() async {
        do {
            self.products = try await Product.products(for: productIDs)
                .sorted(by: { $0.price < $1.price })
        } catch {
            print("Failed to fetch products!")
        }
    }
    
    func buyProduct(_ product: Product) async {
        do {
            let result = try await product.purchase()
            
            switch result {
            case let .success(.verified(transaction)):
                // Successful purhcase
                print("Success")
                await transaction.finish()
                await self.updatePurchasedProducts()
            case let .success(.unverified(_, error)):
                // Successful purchase but transaction/receipt can't be verified
                // Could be a jailbroken phone
                print("Unverified purchase. Might be jailbroken. Error: \(error)")
                break
            case .pending:
                // Transaction waiting on SCA (Strong Customer Authentication) or
                // approval from Ask to Buy
                break
            case .userCancelled:
                print("User cancelled!")
                break
            @unknown default:
                print("Failed to purchase the product!")
                break
            }
        } catch {
            print("Failed to purchase the product!")
        }
    }
    
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }
            let purchaseItem: PurchaseItem = PurchaseItem(id: transaction.productID,purchaseDate: transaction.purchaseDate, expirationDate: transaction.expirationDate)
            
            if transaction.revocationDate == nil {
                self.purchasedProduct.insert(purchaseItem)
            } else {
                self.purchasedProduct.remove(purchaseItem)
            }
        }
        
        self.entitlementManager?.hasPro = !self.purchasedProduct.isEmpty
    }
    
    func restorePurchases() async {
        do {
            try await AppStore.sync()
        } catch {
            print(error)
        }
    }
}

extension SubscriptionsViewModel: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, shouldAddStorePayment payment: SKPayment, for product: SKProduct) -> Bool {
        return true
    }
}
