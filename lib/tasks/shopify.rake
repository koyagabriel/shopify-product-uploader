namespace :shopify do
  desc "Upload products to shopify store"
  task upload_product: :environment do
    ProductUploaderJob.perform_later
  end
end