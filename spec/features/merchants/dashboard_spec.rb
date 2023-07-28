require "rails_helper"

RSpec.describe "merchant dashboard", type: :feature do
  before(:each) do
      @merchant1 = Merchant.create!(name: "Safeway")

      @customer1 = Customer.create!(first_name: "Bob", last_name: "Smith")
      @customer2 = Customer.create!(first_name: "Jane", last_name: "Smith")
      @customer3 = Customer.create!(first_name: "John", last_name: "Smith")
      @customer4 = Customer.create!(first_name: "Janet", last_name: "Smith")
      @customer5 = Customer.create!(first_name: "Johnathan", last_name: "Smith")
      @customer6 = Customer.create!(first_name: "Johnny", last_name: "Smith")
      @customer7 = Customer.create!(first_name: "Joseph", last_name: "Smith")

      @item1 = Item.create!(name: "cheese", description: "its cheese.", unit_price: 1337, merchant_id: @merchant1.id)

      @invoice1 = Invoice.create!(status: "completed", customer_id: @customer1.id)
      @invoice2 = Invoice.create!(status: "completed", customer_id: @customer2.id)
      @invoice3 = Invoice.create!(status: "completed", customer_id: @customer3.id)
      @invoice4 = Invoice.create!(status: "completed", customer_id: @customer4.id)
      @invoice5 = Invoice.create!(status: "completed", customer_id: @customer5.id)
      @invoice6 = Invoice.create!(status: "completed", customer_id: @customer6.id)
      @invoice7 = Invoice.create!(status: "completed", customer_id: @customer6.id)

      @invoice_item1 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice1.id, quantity: 5, unit_price: 13635, status: "pending")
      @invoice_item2 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice2.id, quantity: 9, unit_price: 23324, status: "packaged")
      @invoice_item3 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice3.id, quantity: 9, unit_price: 23324, status: "pending")
      @invoice_item4 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice4.id, quantity: 9, unit_price: 23324, status: "pending")
      @invoice_item5 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice5.id, quantity: 9, unit_price: 23324, status: "pending")
      @invoice_item6 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice6.id, quantity: 9, unit_price: 23324, status: "pending")
      @invoice_item7 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice6.id, quantity: 9, unit_price: 23324, status: "pending")

      @transaction1 = Transaction.create!(invoice_id: @invoice1.id, credit_card_number: "1234567890987654", credit_card_expiration_date: "04/27", result: 0)
      @transaction2 = Transaction.create!(invoice_id: @invoice2.id, credit_card_number: "1234567890987654", credit_card_expiration_date: "04/27", result: 1)
      @transaction3 = Transaction.create!(invoice_id: @invoice3.id, credit_card_number: "1234567890987654", credit_card_expiration_date: "04/27", result: 1)
      @transaction4 = Transaction.create!(invoice_id: @invoice4.id, credit_card_number: "1234567890987654", credit_card_expiration_date: "04/27", result: 1)
      @transaction5 = Transaction.create!(invoice_id: @invoice5.id, credit_card_number: "1234567890987654", credit_card_expiration_date: "04/27", result: 1)
      @transaction6 = Transaction.create!(invoice_id: @invoice6.id, credit_card_number: "1234567890987654", credit_card_expiration_date: "04/27", result: 1)
      @transaction7 = Transaction.create!(invoice_id: @invoice7.id, credit_card_number: "1234567890987654", credit_card_expiration_date: "04/27", result: 1)

  end

  describe "as a merchant" do
    it "when I visit my merchant dashboard I see my merchant name" do
      visit merchant_path(@merchant1)

      expect(page).to have_content("Welcome #{@merchant1.name}")
    end

    it "has a merchant dashboard items index link" do
      visit merchant_path(@merchant1)

      expect(page).to have_link("My Items")
      click_link("My Items")
      expect(current_path).to eq(merchant_items_path(@merchant1)) 

    end

    it "has a merchant dashboard invoices index link" do
      visit merchant_path(@merchant1)

      expect(page).to have_link("My Invoices")
      click_link("My Invoices")
      expect(current_path).to eq(merchant_invoices_path(@merchant1)) 

    end

    describe "Merchant Dashboard Statistics" do
      it "should show largest number of successful transactions" do
        visit merchant_path(@merchant1)

        within "#top_5_customers" do

          expect(page).to have_content("#{@customer6.first_name} #{@customer6.last_name} Successful Transactions: #{@customer6.total_transactions}")
          expect(page).to have_content("#{@customer5.first_name} #{@customer5.last_name} Successful Transactions: #{@customer5.total_transactions}")
          expect(page).to have_content("#{@customer4.first_name} #{@customer4.last_name} Successful Transactions: #{@customer4.total_transactions}")
          expect(page).to have_content("#{@customer3.first_name} #{@customer3.last_name} Successful Transactions: #{@customer3.total_transactions}")
          expect(page).to have_content("#{@customer2.first_name} #{@customer2.last_name} Successful Transactions: #{@customer2.total_transactions}")
        end
      end
    end

    describe "items_ready_to_ship" do
      it "should show item names that have been ordered but not shipped with invoice id" do
        visit merchant_path(@merchant1)
        expect(page).to have_content("Items Ready To Ship")
        # save_and_open_page
        within '#items_ready_to_ship' do

          expect(page).to have_content("Item Name: #{@item1.name}")
          expect(page).to have_link("#{@invoice2.id}")
          click_link("#{@invoice2.id}")
          expect(current_path).to eq("/merchants/#{@merchant1.id}/invoices/#{@invoice2.id}")
        end
      end
    end
  end
end

# 4. Merchant Dashboard Items Ready to Ship

# As a merchant
# When I visit my merchant dashboard (/merchants/:merchant_id/dashboard)
# Then I see a section for "Items Ready to Ship"
# In that section I see a list of the names of all of my items that
# have been ordered and have not yet been shipped,
# And next to each Item I see the id of the invoice that ordered my item
# And each invoice id is a link to my merchant's invoice show page

