namespace :shopify do
  desc "Upload products to shopify store"
  task upload_product: :environment do
    file_url = Figaro.env.file_url || "https://cdn.shopify.com/s/files/1/0418/1141/1097/files/products.json"
    ShopifyService.new(file_url).upload_products
  end
end