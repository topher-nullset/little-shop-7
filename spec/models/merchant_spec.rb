require "rails_helper"

RSpec.describe Merchant, type: :model do
  describe "validations" do
    it { should validate_presence_of :name }
  end

  describe "relationships" do
    it { should have_many :items }
    it { should have_many(:invoices).through(:items) }
    it { should have_many(:transactions).through(:invoices) }
    it { should have_many(:customers).through(:invoices) }
  end

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
    @invoice_item2 = InvoiceItem.create!(item_id: @item1.id, invoice_id: @invoice2.id, quantity: 9, unit_price: 23324, status: "pending")
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
 describe "#top_5_customers" do
  it "should return only the top 5 customers with SUCCESSFUL transactions" do
    top_customers = @merchant1.top_5_customers
    expect(top_customers).to eq([@customer6, @customer2, @customer3, @customer4, @customer5])
    expect(top_customers).to_not eq(@customer1)
  end
 end

end