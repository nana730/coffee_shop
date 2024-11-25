p '==================== cleaning up ===================='
Customer.delete_all
Admin.delete_all
Product.delete_all

p '==================== customer create ===================='
begin
  Customer.create!(name: "田中 一郎", email: "tanaka.ichiro@gmail.com", password: "111111")
  Customer.create!(name: "山田 花子", email: "yamada.hanako@gmail.com", password: "111111")
  Customer.create!(name: "佐藤 健", email: "sato.takeru@gmail.com", password: "111111")
  Customer.create!(name: "斉藤 まさき", email: "saito.masaki@gmail.com", password: "111111")
  Customer.create!(name: "鈴木 太郎", email: "suzuki.taro@gmail.com", password: "111111")
rescue ActiveRecord::RecordInvalid => e
  puts "Failed to create Customer: #{e.record.errors.full_messages}"
end

p '==================== admin create ===================='
begin
  Admin.create!(email: "admin@gmail.com", password: "1234qwer")
rescue ActiveRecord::RecordInvalid => e
  puts "Failed to create Admin: #{e.record.errors.full_messages}"
end

p '==================== product create ===================='

def create_product(name, description, price, stock, acidity, bitterness, sweetness, aroma, body, image_file)
  product = Product.new(
    name: name,
    description: description,
    price: price,
    stock: stock,
    acidity: acidity,
    bitterness: bitterness,
    sweetness: sweetness,
    aroma: aroma,
    body: body
  )
  product.image.attach(io: File.open(Rails.root.join("app/assets/images/#{image_file}")), filename: image_file)

  begin
    product.save!
  rescue ActiveRecord::RecordInvalid => e
    puts "Failed to save product #{name}: #{e.record.errors.full_messages}"
  end
end

create_product(
  "キリマンジャロ",
  "苦味は控えめで、程よい酸味が特徴です。コーヒー初心者の方にぜひ飲んでいただきたいです。",
  1000, 10, 3, 1, 3, 2, 1,
  "coffee1.jpg"
)

create_product(
  "エチオピア",
  "苦目でコクがあります。",
  1200, 15, 4, 2, 2, 5, 3,
  "coffee2.jpg"
)

create_product(
  "コロンビア",
  "バランスの取れた味わいで、世界的に評価が高いコーヒー。
  フルーティーな味わいで、さっぱり飲みやすいです",
  3000, 5, 2, 2, 3, 4, 3,
  "coffee3.jpg"
)

create_product(
  "ブルーマウンテン",
  "ザ・王道の味、癖がなく飲みやすいです。",
  800, 20, 2, 3, 4, 3, 4,
  "coffee4.jpg"
)

create_product(
  "メキシコ",
  "苦味が特徴で、さっぱりとキレがあります。",
  1500, 10, 3, 2, 4, 4, 2,
  "coffee5.jpg"
)

p '==================== seeding complete ===================='
